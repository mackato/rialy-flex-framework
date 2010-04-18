/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.framework.helper {

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.utils.describeType;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;

import org.rialy.framework.action.ActionError;
import org.rialy.framework.action.ActionResult;
import org.rialy.framework.action.IActionMessageReceiver;
import org.rialy.framework.facade.FacadeClient;

/**
 * A super class for ViewHelpers.
 *
 * <p>ViewHelper intermediates between a View component and other classes.
 * A ViewHelper object is created and registered by Facade when View component is registered.</p>
 *
 * <p>ViewHelper subclass must have a View component named 'view'.
 * Event handler methods of the view and some components on the view are marked with EventHandler metadata tags.</p>
 *
 * <p>ViewHelper can receive the execution result of Action via receivers marked with the metadata tags. </p>
 *
 * @example
 * <listing version="3.0">
 * // ViewHelper class name is View component class name + 'Helper'
 * public class MyPanelHelper extends ViewHelper {
 *   
 *   // Subclass must have a View component named 'view'.
 *   public var view:MyPanel;
 *    
 *   // Subclass must have a constructor that receives the View component, and passes the View component to the super class.
 *   public function MyPanelHelper(myPanel:UIComponent) {
 *     super(myPanel);
 *   }
 *    
 *   // Callback method that called when ViewHelper is registered with Facade.
 *   public override function onRegister():void {
 *     facade.registerView(view.childPanel);
 *   }
 *   
 *   // Callback method that called when ViewHelper is removed with Facade.
 *   public override function onRemove():void {
 *     facade.removeView(view.childPanel);
 *   }
 *   
 *   // EventHandlers marked with EventHandler metadata tag.
 *    
 *   // When event source is the view itself, metadata string argument must include only event type.
 *   [EventHandler('initialize')]
 *   public function init(event:Event):void {
 *     ...
 *   } //= view.addEventListener('initialize', init);
 *   
 *   // When event source is an object that on the view, metadata string argument must include the object id and event type.
 *   [EventHandler('button.click')]
 *   public function doSomething(event:Event):void
 *     ...
 *   } //= view.button.addEventListener('click', doSomething);
 *   
 *   // ResultReceiver marked with ResultReceiver metadata tag.
 *   // Following ResultReceiver receives an ActionResult from <code>UserController#login</code>.
 *   [ResultReceiver('user.login')]
 *   public function onLoginSuccess(result:ActionResult):void {
 *     var user:User = result.value as User;
 *     view.user = user;
 *   }
 *   
 *   // ErrorReceiver marked with ErrorReceiver metadata tag.
 *   // Following ErrorReceiver receives an ActionError from <code>ItemController#create.</code>
 *   [ErrorReceiver('item.create')]
 *   public function onItemCreateFail(error:ActionError):void {
 *     Alert.show(error.message);
 *   }
 * }
 * </listing>
 */
public dynamic class ViewHelper extends FacadeClient implements IActionMessageReceiver {

    /**
     * Metadata tag name to mark on a view event handler.
     *
     * <p>This metadata tag must have one string argument that represent event source and type.</p>
     */
    public static const EventHandler:String = "EventHandler";

    /**
     * Metadata tag name to mark on a ActionResult receiver.
     *
     * <p>This metadata tag must have one string argument that represent action name.</p>
     */
    public static const ResultReceiver:String = "ResultReceiver";

    /**
     * Metadata tag name to mark on a ActionError receiver.
     *
     * <p>This metadata tag must have one string argument that represent action name.</p>
     */
    public static const ErrorReceiver:String = "ErrorReceiver";


    private var _eventHandlersDict:Dictionary;
    private var _resultReceiversDict:Dictionary;
    private var _errorReceiversDict:Dictionary;


    /**
     * Creates new ViewHelper.
     *
     * <p>Subclasses must have the same signature of this constructor and call super in constructor.</p>
     *
     * @param viewComponent The UIComponent object that ViewHelper manages.
     * @throws ReferenceError Subclasses must have a read/write property that name is 'view'.
     * If it's not found, this constructor throws ReferenceError.
     */
    public function ViewHelper(viewComponent:UIComponent) {
        this.view = viewComponent;
        _eventHandlersDict = new Dictionary(true);
        _resultReceiversDict = new Dictionary(true);
        _errorReceiversDict = new Dictionary(true);
    }

    /**
     * Describe the ViewHelper type information as XML.
     *
     * @return The XML object that describes the ViewHelper
     */
    public function asXML():XML {
        return _asXML();
    }

    private var _asXML:Function = function():XML {
        var xml:XML = describeType(this);

        this._asXML = function():XML {
            return xml;
        };

        return asXML();
    };

    /**
     * Registers a ViewHelper with Facade.
     *
     * @throws ReferenceError If the object that on the view specified in a EventHandler metadata tag is not found,
     * this method throws ReferenceError.
     */
    public function register():void {
        processMetadata();
        onRegister();
    }

    /**
     * Callback method that called when ViewHelper is registered with Facade.
     *
     * <p>Perform nothing in this base class and do overriding in a subclass and implement it.</p>
     */
    public function onRegister():void {
    }

    /**
     * Remove this ViewHelper with Facade.
     */
    public function remove():void {
        eachEventHandler(removeEventHandler);
        eachResultReceiver(removeResultReceiver);
        eachErrorReceiver(removeErrorReceiver);
        onRemove();
    }

    /**
     * Callback method that called when ViewHelper is removed with Facade.
     *
     * <p>Perform nothing in this base class and do overriding in a subclass and implement it.</p>
     */
    public function onRemove():void {
    }

    /**
     * @inheritDoc
     */
    public function onResult(actionName:String, result:ActionResult):void {
        for each (var receiver:Function in retrieveResultReceivers(actionName)) {
            receiver(result);
        }
    }

    /**
     * @inheritDoc
     */
    public function onError(actionName:String, error:ActionError):void {
        for each (var receiver:Function in retrieveErrorReceivers(actionName)) {
            receiver(error);
        }
    }

    /** @private */
    internal function processMetadata():void {
        var blank:String = '';
        
        for each (var method:XML in asXML().method) {
            var func:Function = this[method.@name] as Function;

            var eventList:XMLList = method.metadata.(@name == EventHandler).arg.(@key == blank).@value;
            for each (var eventName:String in eventList)
                registerEventHandler(eventName, func);

            var resultList:XMLList = method.metadata.(@name == ResultReceiver).arg.(@key == blank).@value;
            for each (var resultName:String in resultList)
                registerResultReceiver(resultName, func);

            var errorList:XMLList = method.metadata.(@name == ErrorReceiver).arg.(@key == blank).@value;
            for each (var errorName:String in errorList)
                registerErrorReceiver(errorName, func);
        }
    }

    /** @private */
    internal function registerEventHandler(eventName:String, handler:Function):void {
        var token:Array = parseEventName(eventName);
        var source:EventDispatcher = token[0];
        var type:String = token[1];

        if (source) {
            source.addEventListener(type, handler);
            storeEventHandler(eventName, handler);
        } else {
            var id:String = eventName.split('.')[0];
            this.view.addEventListener('creationComplete', function(event:Event):void {
                var target:UIComponent = event.target as UIComponent;
                source = target[id];
                if (source) {
                    source.addEventListener(type, handler);
                    storeEventHandler(eventName, handler);
                }
            });
        }
    }

    /** @private */
    internal function retrieveEventHandlers(eventName:String):ArrayCollection {
        var handlers:ArrayCollection = _eventHandlersDict[eventName] as ArrayCollection;
        return handlers ? handlers : new ArrayCollection();
    }

    /** @private */
    internal function removeEventHandler(eventName:String, handler:Function):void {
        var token:Array = parseEventName(eventName);
        var source:EventDispatcher = token[0];
        var type:String = token[1];

        if (source) {
            source.removeEventListener(type, handler);
            var handlers:ArrayCollection = retrieveEventHandlers(eventName);
            for (var i:int = 0; i < handlers.length; i++) {
                var it:Function = handlers[i] as Function;
                if (it == handler) {
                    handlers.removeItemAt(i);
                    if (_eventHandlersDict[eventName].length == 0)
                        delete _eventHandlersDict[eventName];
                    break;
                }
            }
        }
    }

    /** @private */
    internal function eachEventHandler(closure:Function):void {
        for (var eventName:String in _eventHandlersDict) {
            for each (var handler:Function in retrieveEventHandlers(eventName))
                closure(eventName, handler);
        }
    }

    /** @private */
    internal function registerResultReceiver(actionName:String, receiver:Function):void {
        if (!_resultReceiversDict[actionName])
            _resultReceiversDict[actionName] = new ArrayCollection();
        ArrayCollection(_resultReceiversDict[actionName]).addItem(receiver);
    }

    /** @private */
    internal function retrieveResultReceivers(actionName:String):ArrayCollection {
        var receivers:ArrayCollection = _resultReceiversDict[actionName];
        return receivers ? receivers : new ArrayCollection();
    }

    /** @private */
    internal function removeResultReceiver(actionName:String, receiver:Function):void {
        removeFunctionFromDict(_resultReceiversDict, actionName, receiver);
    }

    /** @private */
    internal function eachResultReceiver(closure:Function):void {
        for (var actionName:String in _resultReceiversDict) {
            for each (var receiver:Function in retrieveResultReceivers(actionName))
                closure(actionName, receiver);
        }
    }

    /** @private */
    internal function registerErrorReceiver(actionName:String, receiver:Function):void {
        if (!_errorReceiversDict[actionName])
            _errorReceiversDict[actionName] = new ArrayCollection();
        ArrayCollection(_errorReceiversDict[actionName]).addItem(receiver);
    }

    /** @private */
    internal function retrieveErrorReceivers(actionName:String):ArrayCollection {
        var receivers:ArrayCollection = _errorReceiversDict[actionName];
        return receivers ? receivers : new ArrayCollection();
    }

    /** @private */
    internal function removeErrorReceiver(actionName:String, receiver:Function):void {
        removeFunctionFromDict(_errorReceiversDict, actionName, receiver);
    }

    /** @private */
    internal function eachErrorReceiver(closure:Function):void {
        for (var actionName:String in _errorReceiversDict) {
            for each (var receiver:Function in retrieveErrorReceivers(actionName))
                closure(actionName, receiver)
        }
    }

    private function parseEventName(eventName:String):Array {
        var token:Array = eventName.split('.');
        var source:EventDispatcher = token.length == 1 ? this.view : this.view[token[0]];
        var type:String = token.length == 1 ? eventName : token[1];
        return [source, type];
    }

    private function storeEventHandler(eventName:String, handler:Function):void {
        if (!_eventHandlersDict[eventName])
            _eventHandlersDict[eventName] = new ArrayCollection();
        ArrayCollection(_eventHandlersDict[eventName]).addItem(handler);
    }

    private function removeFunctionFromDict(dict:Dictionary, key:String, func:Function):void {
        var list:ArrayCollection = dict[key] as ArrayCollection;
        if (!list)
            return;

        for (var i:int = 0; i < list.length; i++) {
            var it:Function = list.getItemAt(i) as Function;
            if (it == func) {
                list.removeItemAt(i);
                if (list.length == 0)
                    delete dict[key];
            }
        }
    }
}
}