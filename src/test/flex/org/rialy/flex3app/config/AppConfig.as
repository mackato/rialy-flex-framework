/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.flex3app.config {

import org.rialy.framework.config.Config;
import org.rialy.framework.config.IInitializable;

public class AppConfig extends Config implements IInitializable {

    public var url:String;

    public var appName:String;

    public function AppConfig(env:String = null) {
        super(env);
    }

    // Initialize method work on the development environment.
    public function development():void {
        url = "http://dev.example.com/";

    }

    // Initialize method work on the production environment.
    public function production():void {
        url = "http://prod.example.com/";
    }

    public function initialize():void {
        appName = "flex3app";
    }
}

}