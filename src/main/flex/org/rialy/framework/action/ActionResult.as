/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.action {

/**
 * ActionResult is a result object generated with action name when the action succeeds.
 */
public class ActionResult {

    private var _name:String;

    private var _value:*;

    /**
     * Creates new ActionResult.
     * 
     * @param name The action name.
     * @param value The value of execution result of Action.
     */
    public function ActionResult(name:String, value:* = null) {
        _name = name;
        _value = value;
    }


    /**
     * Return the action name.
     * 
     * @return The action name.
     */
    public function get name():String {
        return _name;
    }

    /**
     * Return the value of execution result of action.
     * 
     * @return The value of execution result of Action.
     */
    public function get value():* {
        return _value;
    }
}
}