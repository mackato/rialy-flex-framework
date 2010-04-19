/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.config {

/**
 * IInitializable is an interface to declare that initialization is required.
 */
public interface IInitializable {
    
    /**
     * Executes an initialization.
     */
    function initialize():void;
}
}