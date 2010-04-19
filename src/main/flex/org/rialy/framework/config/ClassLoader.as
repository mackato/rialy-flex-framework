/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.config {

/**
 * ClassLoader loads the classes registered in class registry.
 */
public class ClassLoader {

    /**
     * Loads the classes registered in class registry.
     *
     * @param registry The Application class registry.
     */
    public static function load(registry:IClassRegistry):void {
        registry.helpers();
        registry.controllers();
    }

    /** @private */
    public function ClassLoader() {
    }
}
}