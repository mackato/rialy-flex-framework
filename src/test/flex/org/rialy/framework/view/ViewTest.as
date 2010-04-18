package org.rialy.framework.view {
    import flexunit.framework.Assert;

    import mx.controls.Button;

    import org.rialy.flex3app.views.AppPanel;

    public class ViewTest {

        private var appPanel:AppPanel;

        public function ViewTest() {
        }

        [Before]
        public function setup():void {
            appPanel = new AppPanel();
        }

        [Test]
        public function testButton():void {
            Assert.assertNull(appPanel.plusButton);

            try {
                appPanel['foo'] = new Button();
                Assert.fail('Button "foo" was not declared');
            } catch (e:ReferenceError) {
                Assert.assertTrue(true);
            } catch (e:Error) {
                Assert.fail('Error type should equal ReferenceError');
            }
        }
    }
}