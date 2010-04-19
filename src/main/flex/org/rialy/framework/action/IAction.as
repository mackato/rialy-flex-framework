/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.action {

/**
 * IAction is an interface to declare it has Action name and delivers the result.
 */
public interface IAction {

    /**
     * Return the action name.
     *
     * @return The action name.
     */
    function get name():String;

    /**
     * Sends the result value of action execution.
     *
     * @param value The result value of action execution.
     */
    function sendValue(value:*):void;

    /**
     * Sends the error of action execution.
     *
     * @param error The error of action execution.
     */
    function sendError(error:Error):void;
}
}