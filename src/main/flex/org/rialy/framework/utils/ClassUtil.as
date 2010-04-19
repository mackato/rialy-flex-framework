/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.utils {

import flash.utils.getQualifiedClassName;

import mx.core.UIComponent;
import mx.utils.StringUtil;

import org.rialy.framework.config.Config;

/**
 * ClassUtil is an utility class that solves the class name by the naming convention of RIALY.
 */
public class ClassUtil {

    /**
     * Returns the qualified class name of ViewHelper from the View component.
     *
     * <p>The package name of the View components is "views", and the package name of ViewHelpers is "helpers".
     * The class name of ViewHelper is a string concat with the View component class name and "helpers".</p>
     *
     * <pre>
     * app.views.MyPanel => app.helpers.MyPanelHelper
     * app.views.sub.MyCanvas => app.helpers.sub.MyCanvasHelper
     * </pre>
     * 
     * @param view The View component.
     * @return The qualified class name of ViewHelper.
     */
    public static function getQualifiedHelperClassNameByView(view:UIComponent):String {
        var viewName:String = getQualifiedClassName(view);

        if (0 < viewName.indexOf("views::"))
            return viewName.replace("views::", "helpers::") + "Helper";
        else
            return viewName.replace("views.", "helpers.") + "Helper";
    }

    /**
     * Returns the qualified class name of ActionController from the short name.
     *
     * <p>The base package of the application is parent of the package where the application config object exists.
     * The package name of the ActionControllers is "controllers", and the class name of ActionControllers is a string
     * concat with the short name and "Controllers".</p>
     *
     * <p>When the base package is "app", the qualified class name can be returned from short name as follows.
     * <pre>
     * "user" => app.controllers.UserController
     * "parent.child" => app.controllers.parent.ChildController
     * </pre>
     * </p>
     *
     * @param shortName The short name of ActionController class name.
     * @param config The application config object.
     * @return The qualified class name of ActionController.
     */
    public static function getQualifiedControllerClassNameByShortName(shortName:String, config:Config):String {
        var token:Array = shortName.split('.');
        var className:String;
        if (token.length == 1) {
            className = shortName.charAt(0).toUpperCase() + shortName.substring(1) + "Controller";
        } else {
            var last:String = token.pop() as String;
            var shortClassName:String = last.charAt(0).toUpperCase() + last.substring(1) + "Controller";
            token.push(shortClassName);
            className = token.join('.');
        }

        return StringUtil.substitute("{0}.controllers.{1}",
                getApplicationBasePackage(config), className);
    }

    private static var getApplicationBasePackage:Function = function(config:Config):String {
        var configName:String = getQualifiedClassName(config);
        var basePackage:String = configName.split('.config::')[0];

        getApplicationBasePackage = function(config:Config):String {
            return basePackage;
        };

        return getApplicationBasePackage(config);
    };

    /** @private */
    public function ClassUtil() {
    }
}

}