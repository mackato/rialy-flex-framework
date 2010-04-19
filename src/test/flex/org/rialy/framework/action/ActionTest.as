/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.framework.action {

import flexunit.framework.Assert;

import mx.events.FlexEvent;

import org.fluint.uiImpersonation.UIImpersonator;
import org.rialy.framework.facade.Facade;
import org.rialy.flex3app.config.AppConfig;
import org.rialy.flex3app.controllers.AppController;
import org.rialy.flex3app.helpers.AppPanelHelper;
import org.rialy.flex3app.views.AppPanel;

/**
 * Action test class.
 */
public class ActionTest {

    private var action:IAction;
    private var facade:Facade;
    private var appPanel:AppPanel;

    public function ActionTest() {
    }

    [BeforeClass]
    public static function initFacade():void {
        Facade.initialize(new AppConfig());
    }

    [Before]
    public function setup():void {
        action = new AppController('app.update');
        facade = Facade.getInstance();
    }

    [Test]
    public function testName():void {
        Assert.assertEquals('app.update', action.name);
    }

    [Test]
    public function testSendResult():void {
        createAppPanel();
        Assert.assertEquals(1, appPanel.count);

        action.sendValue(999);
        Assert.assertEquals(999, appPanel.count);

        cleanupAppPanel();
    }

    [Test]
    public function testSendError():void {
        createAppPanel();

        action.sendError(new Error());
        Assert.assertEquals(-1, appPanel.count);

        cleanupAppPanel();
    }

    private function createAppPanel():void {
        appPanel = new AppPanel();
        facade.registerView(appPanel, AppPanelHelper);
        UIImpersonator.addChild(appPanel);
        appPanel.dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
    }

    private function cleanupAppPanel():void {
        UIImpersonator.removeChild(appPanel);
    }
}
}