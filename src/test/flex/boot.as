/*
 * Copyright (c) 2010. AIRS, inc.
 */
package {

import mx.core.Application;

import org.rialy.framework.config.ClassLoader;
import org.rialy.framework.facade.Facade;
import org.rialy.flex3app.config.AppClassRegistry;
import org.rialy.flex3app.config.AppConfig;
import org.rialy.flex3app.helpers.AppHelper;

function boot(app:Application):void {
    ClassLoader.load(new AppClassRegistry());
    var facade:Facade = Facade.initialize(new AppConfig(CONFIG::ENV));
    facade.registerApplication(app, AppHelper);
}

}