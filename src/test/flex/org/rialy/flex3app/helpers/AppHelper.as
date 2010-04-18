/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.flex3app.helpers {

import mx.core.UIComponent;

import org.rialy.framework.helper.ViewHelper;

/**
 * AppHelper class.
 */
public class AppHelper extends ViewHelper {

    public var view:App;

    public function AppHelper(app:UIComponent) {
        super(app);
    }

    public override function onRegister():void {
        facade.registerView(view.appPanel, AppPanelHelper);
    }
}

}