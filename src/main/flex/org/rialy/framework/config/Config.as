/*
 * Copyright (c) 2010 AIRS.
 */
package org.rialy.framework.config {

/**
 * A super class for the application config class.
 *
 * <p>A RIALY application has only one application config object that extends Config class.
 * The application config object defines the configuration of each environment such as development and production.</p>
 *
 * @example
 * <listing version="3.0">
 * public class ApplicationConfig extends Config {
 *   
 *   // The end point url for remote service;
 *   public var url:String;
 *   
 *   // Subclass must have a constructor with the same signature and call super.
 *   public function ApplicationConfig(env:String) {
 *     super(env);
 *   }
 *   
 *   // Configuration method that works on the development environment.
 *   public function development():void {
 *     url = "http://dev.example.com/";
 *   }
 *   
 *   // Configuration method that works on the production environment.
 *   public function production():void {
 *     url = "http://prod.example.com/";
 *   }
 * }
 * </listing>
 */
public dynamic class Config {

    /**
     * Constant for development environment.
     */
    public static const DEVELOPMENT:String = "development";

    /**
     * Constant for production environment.
     */
    public static const PRODUCTION:String = "production";


    private var _env:String;

    /**
     * Creates new Config.
     *
     * <p>Subclasses must have a constructor with the same signature and call super in constructor.</p>
     *
     * @param env The environment string.
     */
    public function Config(env:String) {
        _env = env ? env : Config.DEVELOPMENT;

        if (this[_env] is Function)
            this[_env].call();
    }

    /**
     * Return the environment as string.
     * 
     * @return The environment string.
     */
    public function get env():String {
        return _env;
    }

    /**
     * Return a true if the current environment is 'development'.
     *
     * @return The boolean value whether the current environment is 'development' or not.
     */
    public function get isDevelopment():Boolean {
        return env == Config.DEVELOPMENT;
    }

    /**
     * Return a true if the current environment is 'production'.
     *
     * @return The boolean value whether the current environment is 'production' or not.
     */
    public function get isProduction():Boolean {
        return env == Config.PRODUCTION;
    }
}
}