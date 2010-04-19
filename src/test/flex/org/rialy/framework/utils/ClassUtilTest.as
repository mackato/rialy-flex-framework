package org.rialy.framework.utils {

import flexunit.framework.Assert;

import org.rialy.flex3app.config.AppConfig;
import org.rialy.flex3app.views.AppPanel;
import org.rialy.flex3app.views.sub.SubPanel;

public class ClassUtilTest {

    public function ClassUtilTest() {
    }

    [Test]
    public function testGetQualifiedHelperClassNameByView():void {
        Assert.assertEquals("org.rialy.flex3app.helpers::AppPanelHelper",
                ClassUtil.getQualifiedHelperClassNameByView(new AppPanel()));

        Assert.assertEquals("org.rialy.flex3app.helpers.sub::SubPanelHelper",
                ClassUtil.getQualifiedHelperClassNameByView(new SubPanel()));
    }

    [Test]
    public function testGetQualifiedControllerClassNameByShortName():void {
        var config:AppConfig = new AppConfig(CONFIG::ENV);

        Assert.assertEquals("org.rialy.flex3app.controllers.AppController",
                ClassUtil.getQualifiedControllerClassNameByShortName("app", config));

        Assert.assertEquals("org.rialy.flex3app.controllers.sub.SubController",
                ClassUtil.getQualifiedControllerClassNameByShortName("sub.sub", config));
    }
}
}