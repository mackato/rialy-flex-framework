package org.rialy.framework.facade {

import flexunit.framework.Assert;

import mx.events.FlexEvent;

import org.fluint.uiImpersonation.UIImpersonator;
import org.rialy.flex3app.config.AppClassRegistry;
import org.rialy.flex3app.config.AppConfig;
import org.rialy.flex3app.helpers.AppHelper;
import org.rialy.flex3app.models.User;
import org.rialy.flex3app.views.AppPanel;
import org.rialy.flex3app.views.NoHelperPanel;
import org.rialy.framework.config.ClassLoader;

public class FacadeTest {

    private var facade:Facade;
    private var appPanel:AppPanel;

    public function FacadeTest() {
    }

    [Before]
    public function setup():void {
        ClassLoader.load(new AppClassRegistry());
        facade = Facade.initialize(new AppConfig());
        appPanel = new AppPanel();
    }

    [Test]
    public function testInitialize():void {
        Assert.assertNotNull(facade);
        Assert.assertEquals('flex3app', facade.config.appName);
        
        var newFacade:Facade = Facade.initialize(new AppConfig());
        Assert.assertFalse(facade == newFacade);
    }

    [Test]
    public function testGetInstance():void {
        var aFacade:Facade = Facade.getInstance();
        Assert.assertStrictlyEquals(facade, aFacade);
    }

    [Test]
    public function testGetObjectIdentifier():void {
        Assert.assertEquals('org.rialy.flex3app.views::AppPanel', facade.getObjectIdentifier(appPanel));
        Assert.assertEquals(facade.getObjectIdentifier(appPanel), facade.getObjectIdentifier(AppPanel));
        
        Assert.assertEquals('org.rialy.flex3app.views::AppPanel-1', facade.getObjectIdentifier(appPanel, 1));
        Assert.assertEquals(facade.getObjectIdentifier(appPanel, 1), facade.getObjectIdentifier(AppPanel, 1));
    }

    [Test]
    public function testRegisterApplication():void {
        var app:App = new App();
        UIImpersonator.addChild(app);
        app.dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));

        facade.registerApplication(app, AppHelper);

        UIImpersonator.removeChild(app);
    }

    [Test]
    public function testRegisterAndRetrieveView():void {
        Assert.assertNull(facade.retrieveView(AppPanel));

        facade.registerView(appPanel);
        Assert.assertStrictlyEquals(appPanel, facade.retrieveView(AppPanel));
        Assert.assertNull(facade.retrieveView(AppPanel, 1));

        var appPanel1:AppPanel = new AppPanel();
        facade.registerView(appPanel1, 1);
        Assert.assertStrictlyEquals(appPanel1, facade.retrieveView(AppPanel, 1));
    }

    [Test(expected="org.rialy.framework.errors.ClassNotFoundError")]
    public function testRegisterViewHelperNotExists():void {
        var noHelperPanel:NoHelperPanel = new NoHelperPanel();
        facade.registerView(noHelperPanel, null);
    }

    [Test]
    public function testRemoveView():void {
        facade.registerView(appPanel);
        Assert.assertNotNull(facade.retrieveView(AppPanel));

        facade.removeView(appPanel);
        Assert.assertNull(facade.retrieveView(AppPanel));
    }

    [Test(expected="org.rialy.framework.errors.ClassNotFoundError")]
    public function testRemoveViewNotExists():void {
        facade.removeView(appPanel, 99);
    }

    [Test]
    public function testIsRegisteredView():void {
        Assert.assertFalse(facade.isRegisteredView(appPanel));
        facade.registerView(appPanel);
        Assert.assertTrue(facade.isRegisteredView(appPanel));

        var appPanel1:AppPanel = new AppPanel();
        Assert.assertFalse(facade.isRegisteredView(appPanel1));
        facade.registerView(appPanel1, 1);
        Assert.assertTrue(facade.isRegisteredView(appPanel1, 1));

        Assert.assertFalse(facade.isRegisteredView(appPanel, 1));
    }

    [Test]
    public function testSendValue():void {
        createAppPanel();
        
        Assert.assertEquals(1, appPanel.count);

        facade.sendValue('app.update', 99);
        Assert.assertEquals(99, appPanel.count);
        
        cleanupAppPanel();
    }

    [Test]
    public function testSendError():void {
        createAppPanel();
        
        facade.sendError('app.update', new Error());
        Assert.assertEquals(-1, appPanel.count);

        cleanupAppPanel();
    }

    [Test]
    public function testExecuteSuccess():void {
        createAppPanel();

        facade.execute('app.update');
        Assert.assertEquals(0, appPanel.count);

        facade.execute('app.update', 1);
        Assert.assertEquals(1, appPanel.count);

        facade.execute('app.update', 1, 2);
        Assert.assertEquals(3, appPanel.count);
        
        facade.execute('app.update', 1, 2, 3);
        Assert.assertEquals(6, appPanel.count);

        facade.execute('app.traceUser', new User('bob', 'bob@example.com'));

        cleanupAppPanel();
    }

    [Test(expected="org.rialy.framework.errors.ClassNotFoundError")]
    public function testExecuteErrorControllerNotFound():void {
        facade.execute('foo.update');
    }

    [Test(expected="ReferenceError")]
    public function testExecuteErrorActionNotFound():void {
        facade.execute('app.bar');
    }

    [Test(expected="ArgumentError")]
    public function testExecuteErrorParameterTooLess():void {
        facade.execute('app.traceUser');
    }

    [Test(expected="ArgumentError")]
    public function testExecuteErrorParameterTooMany():void {
        facade.execute('app.traceUser', 1, 2);
    }

    [Test(expected="TypeError")]
    public function testExecuteErrorParameterTypeInvalid():void {
        facade.execute('app.traceUser', "bob");
    }

    private function createAppPanel():void {
        facade.registerView(appPanel);
        UIImpersonator.addChild(appPanel);
        appPanel.dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
    }

    private function cleanupAppPanel():void {
        UIImpersonator.removeChild(appPanel);
    }
}

}