package org.rialy.framework.helper {

import flash.events.Event;
import flash.events.MouseEvent;

import flexunit.framework.Assert;

import mx.controls.Button;
import mx.events.FlexEvent;
import mx.utils.StringUtil;

import org.fluint.uiImpersonation.UIImpersonator;
import org.rialy.framework.action.ActionError;
import org.rialy.framework.action.ActionResult;
import org.rialy.framework.facade.Facade;
import org.rialy.flex3app.config.AppConfig;
import org.rialy.flex3app.helpers.AppPanelHelper;
import org.rialy.flex3app.views.AppPanel;

public class ViewHelperTest {

    private var appPanelHelper:AppPanelHelper;
    private var appPanel:AppPanel;

    public function ViewHelperTest() {
    }

    [BeforeClass]
    public static function onLoad():void {
        Facade.initialize(new AppConfig(CONFIG::ENV));
    }

    [Before]
    public function setup():void {
        appPanel = new AppPanel();
        appPanelHelper = new AppPanelHelper(appPanel);
    }

    [Test]
    public function testView():void {
        Assert.assertObjectEquals(appPanel, appPanelHelper.view);
    }

    [Test]
    public function testAsXML():void {
        var xml:XML = appPanelHelper.asXML();
        Assert.assertNotNull(xml);
    }

    [Test]
    public function testRegister():void {
        Assert.assertEquals(0, appPanel.count);
        appPanelHelper.register();
        Assert.assertEquals(1, appPanel.count);
    }

    [Test]
    public function testRemove():void {
        appPanelHelper.register();
        Assert.assertEquals(1, appPanel.count);
        appPanelHelper.remove();
        Assert.assertEquals(99, appPanel.count);
    }

    [Test]
    public function testRegisterEventHandler():void {
        appPanelHelper.registerEventHandler('creationComplete', onEvent);
        Assert.assertEquals(1, appPanelHelper.retrieveEventHandlers('creationComplete').length);

        appPanelHelper.registerEventHandler('plusButton.click', onEvent);
        Assert.assertEquals('plusButton was not created yet.',
                0, appPanelHelper.retrieveEventHandlers('plusButton.click').length);

        appPanel.plusButton = new Button();
        appPanelHelper.registerEventHandler('plusButton.click', onEvent);
        Assert.assertEquals(1, appPanelHelper.retrieveEventHandlers('plusButton.click').length);
    }

    [Test(ui)]
    public function testRegisterEventHandlerAfterUICreation():void {
        var eventName:String = 'plusButton.click';
        appPanelHelper.registerEventHandler(eventName, onEvent);
        appPanelHelper.registerEventHandler(eventName, onEvent);
        Assert.assertEquals(0, appPanelHelper.retrieveEventHandlers(eventName).length);

        UIImpersonator.addChild(appPanel);
        appPanel.dispatchEvent(new FlexEvent(FlexEvent.CREATION_COMPLETE));
        Assert.assertEquals(2, appPanelHelper.retrieveEventHandlers(eventName).length);

        UIImpersonator.removeChild(appPanel);
    }

    [Test(ui)]
    public function testHandleButtonEvent():void {
        UIImpersonator.addChild(appPanel);
        appPanelHelper.register();
        Assert.assertEquals(1, appPanel.count);

        appPanel.plusButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        Assert.assertEquals(2, appPanel.count);

        appPanel.minusButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        Assert.assertEquals(1, appPanel.count);

        UIImpersonator.removeChild(appPanel);
    }

    [Test(expected="ReferenceError")]
    public function testRegisterEventHandlerErrorComponentNotFound():void {
        // Property "link" was not declared
        appPanelHelper.registerEventHandler('link.click', onEvent);
    }

    [Test]
    public function testRemoveEventHandler():void {
        var eventName:String = 'creationComplete';
        appPanelHelper.registerEventHandler(eventName, onEvent);
        appPanelHelper.registerEventHandler(eventName, onEvent);
        Assert.assertEquals(2, appPanelHelper.retrieveEventHandlers(eventName).length);

        appPanelHelper.removeEventHandler(eventName, onEvent);
        Assert.assertEquals(1, appPanelHelper.retrieveEventHandlers(eventName).length);

        appPanelHelper.removeEventHandler(eventName, onEvent);
        Assert.assertEquals(0, appPanelHelper.retrieveEventHandlers(eventName).length);
    }

    [Test(expected="ReferenceError")]
    public function testRemoveEventHandlerErrorEventNameNotFound():void {
        appPanelHelper.removeEventHandler('link.click', onEvent);
    }

    [Test]
    public function testEachEventHandler():void {
        var count:int = 0;
        appPanelHelper.register();
        appPanelHelper.eachEventHandler(function(eventName:String, handler:Function):void {
            count++;
        });
        Assert.assertEquals(2, count);
    }

    [Test]
    public function testRegisterResultReceiver():void {
        appPanelHelper.registerResultReceiver('app.update', onResult);
        Assert.assertEquals(1, appPanelHelper.retrieveResultReceivers('app.update').length);
    }

    [Test]
    public function testRemoveResultReceiver():void {
        var actionName:String = 'app.update';
        appPanelHelper.registerResultReceiver(actionName, onResult);
        appPanelHelper.registerResultReceiver(actionName, onResult);
        Assert.assertEquals(2, appPanelHelper.retrieveResultReceivers(actionName).length);

        appPanelHelper.removeResultReceiver(actionName, onResult);
        Assert.assertEquals(1, appPanelHelper.retrieveResultReceivers(actionName).length);

        appPanelHelper.removeResultReceiver(actionName, onResult);
        Assert.assertEquals(0, appPanelHelper.retrieveResultReceivers(actionName).length);
    }

    [Test]
    public function testEachResultReceiver():void {
        var count:int = 0;
        appPanelHelper.register();
        appPanelHelper.eachResultReceiver(function(actionName:String, receiver:Function):void {
            count++;
        });
        Assert.assertEquals(3, count);
    }

    [Test]
    public function testRegisterErrorReceiver():void {
        appPanelHelper.registerErrorReceiver('app.update', onError);
        Assert.assertEquals(1, appPanelHelper.retrieveErrorReceivers('app.update').length);
    }

    [Test]
    public function testRemoveErrorReceiver():void {
        var actionName:String = 'app.update';
        appPanelHelper.registerErrorReceiver(actionName, onError);
        appPanelHelper.registerErrorReceiver(actionName, onError);
        Assert.assertEquals(2, appPanelHelper.retrieveErrorReceivers(actionName).length);

        appPanelHelper.removeErrorReceiver(actionName, onError);
        Assert.assertEquals(1, appPanelHelper.retrieveErrorReceivers(actionName).length);

        appPanelHelper.removeErrorReceiver(actionName, onError);
        Assert.assertEquals(0, appPanelHelper.retrieveErrorReceivers(actionName).length);
    }

    [Test]
    public function testEachErrorReceiver():void {
        var count:int = 0;
        appPanelHelper.register();
        appPanelHelper.eachErrorReceiver(function(actionName:String, receiver:Function):void {
            count++;
        });
        Assert.assertEquals(3, count);
    }

    [Test]
    public function testOnResult():void {
        var actionName:String = 'app.update';
        appPanelHelper.register();
        Assert.assertEquals(2, appPanelHelper.retrieveResultReceivers(actionName).length);

        var result:ActionResult = new ActionResult('app.update', 100);
        appPanelHelper.onResult(actionName, result);
        Assert.assertEquals(100, appPanel.count);
    }

    [Test]
    public function testOnError():void {
        var actionName:String = 'app.update';
        appPanelHelper.register();
        Assert.assertEquals(2, appPanelHelper.retrieveErrorReceivers(actionName).length);

        var error:ActionError = new ActionError('app.update', new Error());
        appPanelHelper.onError(actionName, error);
        Assert.assertEquals(-1, appPanel.count);
    }


    private function onEvent(event:Event):void {
        trace(StringUtil.substitute("Event: {0} {1}", event.target, event.type));
    }

    private function onResult(result:ActionResult):void {
        trace(result.name);
    }

    private function onError(error:ActionError):void {
        trace(error.message);
    }
}
}