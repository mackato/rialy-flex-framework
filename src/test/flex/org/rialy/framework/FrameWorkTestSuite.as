/*
 * Copyright (c) 2010. AIRS, inc.
 */
package org.rialy.framework {

import org.rialy.framework.action.ActionErrorTest;
import org.rialy.framework.action.ActionResultTest;
import org.rialy.framework.action.ActionTest;
import org.rialy.framework.config.ClassLoaderTest;
import org.rialy.framework.config.ConfigTest;
import org.rialy.framework.facade.FacadeTest;
import org.rialy.framework.helper.ViewHelperTest;
import org.rialy.framework.utils.ClassUtilTest;
import org.rialy.framework.view.ViewTest;

/**
 * FrameWorkTestSuite class.
 */
[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class FrameWorkTestSuite {

    public function FrameWorkTestSuite() {
    }

    // package action

    public var actionErrorTest:ActionErrorTest;

    public var actionResultTest:ActionResultTest;

    public var actionTest:ActionTest;


    // package config

    public var classLoaderTest:ClassLoaderTest;

    public var configTest:ConfigTest;


    // package facade

    public var facadeTest:FacadeTest;


    // package helper

    public var viewHelperTest:ViewHelperTest;
    

    // package view

    public var viewTest:ViewTest;

    // package utils

    public var classUtilTest:ClassUtilTest;
}

}