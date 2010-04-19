/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.flex3app.helpers {

import flash.events.Event;

import mx.core.UIComponent;
import mx.utils.StringUtil;

import org.rialy.flex3app.views.AppPanel;
import org.rialy.framework.action.ActionError;
import org.rialy.framework.action.ActionResult;
import org.rialy.framework.helper.*;

public class AppPanelHelper extends ViewHelper {

    public var view:AppPanel;

    public function AppPanelHelper(appPanel:UIComponent) {
        super(appPanel);
        view.count = 0;
    }

    public override function onRegister():void {
        view.count = 1;
    }

    public override function onRemove():void {
        view.count = 99;
    }

    [EventHandler('initialize')]
    [EventHandler('creationComplete')]
    public function handleViewEvent(event:Event):void {
        traceEvent(event);
    }

    [EventHandler('plusButton.click')]
    public function increment(event:Event):void {
        view.count++;
    }

    [EventHandler('minusButton.click')]
    public function decrement(event:Event):void {
        view.count--;
        traceEvent(event);
    }

    [EventHandler('plusButton.click')]
    public function traceClick(event:Event):void {
        traceEvent(event);
    }

    [ResultReceiver('app.update')]
    public function updateCount(result:ActionResult):void {
        view.count = result.value;
    }

    [ResultReceiver('app.update')]
    [ResultReceiver('foo.bar')]
    public function traceUpdate(result:ActionResult):void {
        trace(result.value);
    }

    [ErrorReceiver('app.update')]
    public function resetCount(error:ActionError):void {
        view.count = -1;
        trace(error.name);
    }

    [ErrorReceiver('app.update')]
    [ErrorReceiver('foo.bar')]
    public function traceError(error:ActionError):void {
        trace(error.message);
    }

    private function traceEvent(event:Event):void {
        trace(StringUtil.substitute("Event: {0}#{1}", event.target, event.type));
    }
}
}