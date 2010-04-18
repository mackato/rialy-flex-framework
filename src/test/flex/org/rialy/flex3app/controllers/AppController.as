package org.rialy.flex3app.controllers {

import org.rialy.framework.action.ActionController;
import org.rialy.flex3app.models.User;

/**
 * AppController class.
 */
public class AppController extends ActionController {
    
    public function AppController(name:String) {
        super(name);
    }

    public function update(param1:int = 0, param2:int = 0, param3:int = 0):void {
        sendValue(param1 + param2 + param3);
    }

    public function traceUser(user:User):void {
        trace(user.name + "<" + user.email + ">");
    }
}

}