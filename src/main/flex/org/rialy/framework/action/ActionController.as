/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.action {

import org.rialy.framework.facade.FacadeClient;

/**
 * A super class for ActionControllers.
 *
 * <p>ActionController implements IAction interface, and subclasses have some action methods.
 * An ActionController object is instantiated by Facade at each execution and action name is given. </p>
 *
 * <p>Facade gives an action name based on a simple naming convention to an ActionController object.</p>
 * <pre>
 * UserController#login => "user.login"
 * ItemController#create => "item.create"
 * </pre>
 *
 * <p>After executing action, ActionController sends the execution result to receivers.</p>
 *
 * @example
 * <listing version="3.0">
 * public class MyController extends ActionController {
 *   
 *   // Subclass must have a constructor with the same signature and call super.
 *   public function MyController(name:String) {
 *     super(name);
 *   }
 *   
 *   // Synchronous action method. Action method can receive several parameters.
 *   public function mySyncAction(message:String):void {
 *     try {
 *       ...
 *       sendValue(message);
 *     } catch (error:Error) {
 *       sendError(error);
 *     }
 *   }
 *   
 *   // Asynchronous action method.
 *   public function myAsyncAction():void {
 *     ...
 *     service.addEventListener(ResultEvent.RESULT, resultHandler);
 *     service.hello("World");
 *   }
 *   
 *   // Send the execution result value in callback method.
 *   public function resultHandler(event:ResultEvent):void {
 *     sendValue(event.result);
 *   }
 * }
 * </listing>
 */
public class ActionController extends FacadeClient implements IAction {

    private var _name:String;

    /**
     * Creates new ActionController.
     *
     * <p>Subclasses must have a constructor with the same signature and call super in constructor.</p>
     *
     * @param name The action name.
     */
    public function ActionController(name:String) {
        _name = name;
    }

    /**
     * Return a action name.
     *
     * @return The action name.
     */
    public function get name():String {
        return _name;
    }

    /** @inheritDoc */
    public function sendValue(value:*):void {
        facade.sendValue(name, value);
    }

    /** @inheritDoc */
    public function sendError(error:Error):void {
        facade.sendError(name, error);
    }
}
}