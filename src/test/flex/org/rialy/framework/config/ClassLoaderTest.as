package org.rialy.framework.config {

import flash.utils.getDefinitionByName;

import flexunit.framework.Assert;

import org.rialy.framework.utils.ClassUtil;
import org.rialy.flex3app.config.AppClassRegistry;
import org.rialy.flex3app.views.AppPanel;

/**
 * ClassLoaderTest class.
 */
public class ClassLoaderTest {

    public function ClassLoaderTest() {
    }

    [Test]
    public function testLoad():void {
        ClassLoader.load(new AppClassRegistry());
        var controllerClass:Class =
                getDefinitionByName(ClassUtil.getQualifiedHelperClassNameByView(new AppPanel())) as Class;
        Assert.assertNotNull(controllerClass);
    }
}
}