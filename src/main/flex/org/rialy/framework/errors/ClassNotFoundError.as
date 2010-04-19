/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.errors {

/**
 * ClassNotFoundError is an error that occurs when an actual class is not found from the name of the class.
 */
public class ClassNotFoundError extends Error {

    /**
     * Creates new ClassNotFoundError.
     *
     * @param message The message to explain cause.
     * @param errorID The error id.
     */
    public function ClassNotFoundError(message:String = null, errorID:int = 0) {
        super(message, errorID);
    }
}
}