//
//  Easing.swift
//  HealthScenarios
//
//  Created by Bharat Mediratta on 11/24/16.
//  Copyright © 2016 Bharat Mediratta. All rights reserved.
//
//  Easing equations from: http://gizma.com/easing/

import Foundation
import Darwin

class Easing {
    
    // t: current time
    // b: start value
    // c: change in value
    // d: duration

    // simple linear tweening - no easing, no acceleration
    static func linearTween(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c*t/d + b
    }

    // quadratic easing in - accelerating from zero velocity
    static func easeInQuad(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        return c*t*t + b
    }

    // quadratic easing out - decelerating to zero velocity
    static func easeOutQuad(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        return -c * t*(t-2) + b
    }

    // quadratic easing in/out - acceleration until halfway, then deceleration
    static func easeInOutQuad(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d/2
        if (t < 1) {
            return c/2*t*t + b
        }
        t -= 1
        return -c/2 * (t*(t-2) - 1) + b
    }

    // cubic easing in - accelerating from zero velocity
    static func easeInCubic(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        return c*t*t*t + b
    }

    // cubic easing out - decelerating to zero velocity
    static func easeOutCubic(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        t -= 1
        return c*(t*t*t + 1) + b
    }

    // cubic easing in/out - acceleration until halfway, then deceleration
    static func easeInOutCubic(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d/2
        if (t < 1) {
            return c/2*t*t*t + b
        }
        t -= 2
        return c/2*(t*t*t + 2) + b
    }

    // quartic easing in - accelerating from zero velocity
    static func easeInQuart(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        return c*t*t*t*t + b
    }

    // quartic easing out - decelerating to zero velocity
    static func easeOutQuart(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        t -= 1
        return -c * (t*t*t*t - 1) + b
    }

    // quartic easing in/out - acceleration until halfway, then deceleration
    static func easeInOutQuart(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d/2
        if (t < 1) {
            return c/2*t*t*t*t + b
        }
        t -= 2
        return -c/2 * (t*t*t*t - 2) + b
    }

    // quintic easing in - accelerating from zero velocity
    static func easeInQuint(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        return c*t*t*t*t*t + b
    }

    // quintic easing out - decelerating to zero velocity
    static func easeOutQuint(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        t -= 1
        return c*(t*t*t*t*t + 1) + b
    }

    // quintic easing in/out - acceleration until halfway, then deceleration
    static func easeInOutQuint(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d/2
        if (t < 1) {
            return c/2*t*t*t*t*t + b
        }
        t -= 2
        return c/2*(t*t*t*t*t + 2) + b
    }

    // sinusoidal easing in - accelerating from zero velocity
    static func easeInSine(t: Double, b: Double, c: Double, d: Double) -> Double {
        return -c * cos(t/d * (Double.pi/2)) + c + b
    }

    // sinusoidal easing out - decelerating to zero velocity
    static func easeOutSine(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * sin(t/d * (Double.pi/2)) + b
    }

    // sinusoidal easing in/out - accelerating until halfway, then decelerating
    static func easeInOutSine(t: Double, b: Double, c: Double, d: Double) -> Double {
        return -c/2 * (cos(Double.pi*t/d) - 1) + b
    }

    // exponential easing in - accelerating from zero velocity
    static func easeInExpo(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * pow( 2, 10 * (t/d - 1) ) + b
    }

    // exponential easing out - decelerating to zero velocity
    static func easeOutExpo(t: Double, b: Double, c: Double, d: Double) -> Double {
        return c * ( -pow( 2, -10 * t/d ) + 1 ) + b
    }

    // exponential easing in/out - accelerating until halfway, then decelerating
    static func easeInOutExpo(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d/2
        if (t < 1) {
            return c/2 * pow(2, 10 * (t - 1) ) + b
        }
        t -= 1
        return c/2 * ( -pow( 2, -10 * t) + 2 ) + b
    }

    // circular easing in - accelerating from zero velocity
    static func easeInCirc(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        return -c * (sqrt(1 - t*t) - 1) + b
    }

    // circular easing out - decelerating to zero velocity
    static func easeOutCirc(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d
        t -= 1
        return c * sqrt(1 - t*t) + b
    }

    // circular easing in/out - acceleration until halfway, then deceleration
    static func easeInOutCirc(t: Double, b: Double, c: Double, d: Double) -> Double {
    	var t = t
        t /= d/2
        if (t < 1) {
            return -c/2 * (sqrt(1 - t*t) - 1) + b
        }
        t -= 2
        return c/2 * (sqrt(1 - t*t) + 1) + b
    }


}
