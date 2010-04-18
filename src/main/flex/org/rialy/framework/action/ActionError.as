/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.action {

/**
 * ActionError is Error class generated with the action name when it makes an error of the action.
 */
public class ActionError extends Error {

    private var _cause:Error;

    /**
     * Creates new ActionError.
     *
     * @param name The action name.
     * @param cause The error that caused this ActionError.
     */
    public function ActionError(name:String, cause:Error) {
        super(cause.message, cause.errorID);
        _cause = cause;
        this.name = name;
    }

    /**
     * Returns the Error that caused this ActionError.
     *
     * @return The error that caused this ActionError.
     */
    public function get cause():Error {
        return _cause;
    }
}
}