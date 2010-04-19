/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.framework.action {
    import flexunit.framework.Assert;

    /**
     * ActionErrorTest class.
     */
    public class ActionErrorTest {

        private var actionError:ActionError;

        public function ActionErrorTest() {
        }

        [Test]
        public function testActionError():void {
            var error:Error = new Error();
            actionError = new ActionError("app.update", error);
            Assert.assertEquals("app.update", actionError.name);
            Assert.assertStrictlyEquals(error, actionError.cause);
            Assert.assertEquals("", actionError.message);
            Assert.assertEquals(0, actionError.errorID);

            error = new Error("test", 1)
            actionError = new ActionError("app.update", error);
            Assert.assertEquals("test", actionError.message);
            Assert.assertEquals(1, actionError.errorID);
        }
    }
}