package org.rialy.flex3app.config {

import org.rialy.framework.config.IClassRegistry;
import org.rialy.flex3app.controllers.AppController;
import org.rialy.flex3app.helpers.AppPanelHelper;

/**
 * AppClassRegistry class.
 */
public class AppClassRegistry implements IClassRegistry {

    public function AppClassRegistry() {
    }

    public function helpers():Array {
        return [
            AppPanelHelper
        ];
    }

    public function controllers():Array {
        return [
            AppController
        ];
    }
}

}