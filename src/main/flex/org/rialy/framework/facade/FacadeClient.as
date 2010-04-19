/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.facade {

import org.rialy.framework.config.Config;

/**
 * A super class for FacadeClients.
 *
 * <p>Subclasses can easily access Facade and application config object.</p>
 * <p>ViewHelpers and ActionControllers are extend this class.</p>
 */
public class FacadeClient {

    /**
     * Return the Facade object.
     *
     * @return The Facade object.
     */
    protected function get facade():Facade {
        return Facade.getInstance();
    }

    /**
     * Return the application config object through facade.
     *
     * @return The application config object.
     */
    protected function get config():Config {
        return facade.config;
    }

    /**
     * Subclasses not have to call this constructor.
     */
    public function FacadeClient() {
    }
}
}