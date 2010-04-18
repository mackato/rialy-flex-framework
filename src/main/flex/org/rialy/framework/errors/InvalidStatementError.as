/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.errors {

/**
 * InvalidStatementError is an error that occurs when the application is not correctly initialized
 * and the state is invalid.
 */
public class InvalidStatementError extends Error {
    
    /**
     * Creates new InvalidStatementError.
     *
     * @param message The message to explain cause.
     * @param errorID The error id.
     */
    public function InvalidStatementError(message:String = "", errorID:int = 0) {
        super(message, errorID);
    }
}
}