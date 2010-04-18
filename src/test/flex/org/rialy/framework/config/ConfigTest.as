/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.framework.config {

import flexunit.framework.Assert;

import org.rialy.flex3app.config.AppConfig;

public class ConfigTest {

    private var config:Config;

    public function ConfigTest() {
        super();
    }

    [Before]
    public function setup():void {
        config = new AppConfig(CONFIG::ENV);
    }

    [Test]
    public function testEnv():void {
        if (!config.isProduction)
            Assert.assertEquals('Default env should be "development"', 'development', config.env);
    }

    [Test]
    public function testEnvFunction():void {
        if (config.isDevelopment)
            Assert.assertEquals('Development initilalizer should be called',
                    'http://dev.example.com/', config.url);

        if (config.isProduction)
            Assert.assertEquals('Production initilalizer should be called',
                    'http://prod.example.com/', config.url);
    }

    [Test]
    public function testInitialize():void {
        Assert.assertNull(config.appName);
        config.initialize();
        Assert.assertNotNull(config.appName);
    }
}
}