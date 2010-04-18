/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.action {

/**
 * IActionMessageReceiver is an interface to declare it receives the execution result of Action.  
 */
public interface IActionMessageReceiver {

    /**
     * Called when action succeeds.
     * 
     * @param name The action name.
     * @param result The ActionResult object.
     */
    function onResult(name:String, result:ActionResult):void;

    /**
     * Called when action fails.
     *
     * @param name The action name.
     * @param error The ActionError object.
     */
    function onError(name:String, error:ActionError):void;
}
}