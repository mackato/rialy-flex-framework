/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.config {

/**
 * IClassRegistry is an interface to declare the methods for the registration of the class generated with the reflection.
 *
 * <p>A RIALY application has only one application class registry object that implements IClassRegistry interface.</p>
 */
public interface IClassRegistry {

    /**
     * Return the list of ViewHelper subclasses used in Application.
     *
     * @return The list of ViewHelper subclasses.
     */
    function helpers():Array;

    /**
     * Return the list of ActionController subclasses used in Application.
     *
     * @return The list of ActionController subclasses.
     */
    function controllers():Array;
}
}