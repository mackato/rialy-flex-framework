/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.framework.action {

import flexunit.framework.Assert;

/**
     * ActionResultTest class.
     */
    public class ActionResultTest {

        private var result:ActionResult;

        public function ActionResultTest() {
        }

        [Test]
        public function testConstructor():void {
            result = new ActionResult("app.update", 1);
            Assert.assertEquals(1, result.value);

            result = new ActionResult("app.update");
            Assert.assertNull(result.value);
        }
    }
}