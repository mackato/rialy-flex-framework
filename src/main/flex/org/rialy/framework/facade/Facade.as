/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.facade {

import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;

import mx.core.UIComponent;
import mx.utils.StringUtil;

import org.rialy.framework.action.ActionController;
import org.rialy.framework.action.ActionError;
import org.rialy.framework.action.ActionResult;
import org.rialy.framework.action.IActionMessageReceiver;
import org.rialy.framework.config.Config;
import org.rialy.framework.config.IInitializable;
import org.rialy.framework.errors.ClassNotFoundError;
import org.rialy.framework.errors.InvalidStatementError;
import org.rialy.framework.helper.ViewHelper;
import org.rialy.framework.utils.ClassUtil;

/**
 * Facade is singleton object that manages the communication between classes in the application.
 *
 * <p>In RIALY, the Facade assumes these responsibilities.</p>
 *
 * <ul>
 *   <li>Registering the View/ViewHelper.</li>
 *   <li>Executing the action and delivering its result.</li>
 *   <li>Offering application config to clients.</li>
 * </ul>
 */
public class Facade {

    /**
     * Creates new Facade and processes initialization.
     *
     * @param config The application config object.
     * @return The facade.
     */
    public static function initialize(config:Config):Facade {
        var facade:Facade = new Facade(config);

        var initializable:IInitializable = config as IInitializable;
        if (initializable)
            initializable.initialize();

        _getInstance = function():Facade {
            return facade;
        };

        return getInstance();
    }

    /**
     * Return the singleton Facade.
     *
     * @return The Facade.
     * @throw InvalidStatementError Throwing InvalidStatementError if facade is not initialized.
     */
    public static function getInstance():Facade {
        return _getInstance();
    }

    private static var _getInstance:Function = function():Facade {
        throw new InvalidStatementError("Facade is not initialized yet.");
    };

    private var _config:Config;

    private var _views:Dictionary;

    private var _helpers:Dictionary;

    /** @private */
    function Facade(config:Config) {
        _config = config;
        _views = new Dictionary(true);
        _helpers = new Dictionary(true);
    }

    /**
     * Return the application config object.
     *
     * @return The application config object.
     */
    public function get config():Config {
        return _config;
    }

    /**
     * Registers the application main View.
     *
     * @param app The application main View.
     * @param helperClass The ViewHelper class that manages the application main View.
     */
    public function registerApplication(app:UIComponent, helperClass:Class):void {
        registerAndStore(app, helperClass);
    }

    /**
     * Registers the View component.
     *
     * @param view The View component.
     * @param id The ID to identify View component if necessary.
     * @throws ClassNotFoundError Throwing ClassNotFoundError if ViewHelper that pairs with View component is not found.
     */
    public function registerView(view:UIComponent, id:* = null):void {
        var helperClassName:String = ClassUtil.getQualifiedHelperClassNameByView(view);

        try {
            var helperClass:Class = getDefinitionByName(helperClassName) as Class;
            registerAndStore(view, helperClass, id);
        } catch (e:ReferenceError) {
            throw new ClassNotFoundError(buildViewHelperClassNotFoundMessage(helperClassName), e.errorID);
        }
    }

    private function buildViewHelperClassNotFoundMessage(className:String):String {
        return StringUtil.substitute(
                "ViewHelper subclass '{0}' was not found. " +
                "Please check the helpers() method in the application class registry.",
                className);
    }

    /**
     * Find and return the View component.
     *
     * @param viewClass The View component class.
     * @param id The ID to identify View component if necessary.
     * @return The View component.
     */
    public function retrieveView(viewClass:Class, id:* = null):UIComponent {
        return _views[getObjectIdentifier(viewClass, id)];
    }


    /**
     * Remove the View component.
     *
     * @param view The View component.
     * @param id The ID to identify View component if necessary.
     * @throws ClassNotFoundError Throwing ClassNotFoundError if ViewHelper that pairs with View component is not found.
     */
    public function removeView(view:UIComponent, id:* = null):void {
        var viewId:String = getObjectIdentifier(view, id);

        try {
            var helper:ViewHelper = _helpers[viewId];

            helper.remove();
        } catch (e:TypeError) {
            var helperClassName:String = ClassUtil.getQualifiedHelperClassNameByView(view);
            throw new ClassNotFoundError(buildViewHelperClassNotFoundMessage(helperClassName), e.errorID);
        }

        delete _views[viewId];
        delete _helpers[viewId];
    }

    /**
     * Return a true if the View component is registered.
     *
     * @param view The View component.
     * @return The boolean value whether the View component is registered or not.
     */
    public function isRegisteredView(view:UIComponent, id:* = null):Boolean {
        return (view === _views[getObjectIdentifier(view, id)])
    }

    /**
     * Sends the value with action name.
     *
     * @param actionName The action name.
     * @param value The result value of action execution.
     */
    public function sendValue(actionName:String, value:*):void {
        var result:ActionResult = new ActionResult(actionName, value);
        for each (var receiver:IActionMessageReceiver in _helpers) {
            receiver.onResult(actionName, result);
        }
    }

    /**
     * Sends the error with action name.
     * 
     * @param actionName The action name.
     * @param error The error of action execution.
     */
    public function sendError(actionName:String, error:Error):void {
        var actionError:ActionError = new ActionError(actionName, error);
        for each (var receiver:IActionMessageReceiver in _helpers) {
            receiver.onError(actionName, actionError);
        }
    }

    /**
     * Executes the action that specified by the action name.
     *
     * @param actionName The action name.
     * @param params The parameters for action method if necessary.
     * @throws ClassNotFoundError Throwing ClassNotFoundError if IAction is not found by action name.
     */
    public function execute(actionName:String, ...params):void {
        var token:Array = actionName.split('.');
        var action:String = token.pop();
        var controllerName:String = ClassUtil.getQualifiedControllerClassNameByShortName(token.join('.'), config);
        var controllerClass:Class;

        try {
            controllerClass = getDefinitionByName(controllerName) as Class;
        } catch (e:ReferenceError) {
            var message:String =
                    StringUtil.substitute(
                            "ActionController subclass '{0}' was not found. " +
                            "Please check the controllers() method in the application class registry.",
                            controllerName);
            throw new ClassNotFoundError(message, e.errorID);
        }

        var controller:ActionController = new controllerClass(actionName) as ActionController;
        controller[action].apply(controller, params);
    }

    /** @private */
    internal function getObjectIdentifier(obj:*, id:* = null):String {
        var className:String = getQualifiedClassName(obj);
        return id ?
               StringUtil.substitute("{0}-{1}", className, id) :
               className;
    }

    private function registerAndStore(view:UIComponent, helperClass:Class, id:* = null):void {
        var helper:ViewHelper = new helperClass(view) as ViewHelper;
        helper.register();

        var viewId:String = getObjectIdentifier(view, id);
        _views[viewId] = view;
        _helpers[viewId] = helper;
    }
}

}