//
//  FloatExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/6.
//

import Foundation
import CoreGraphics

public extension Float {
    
    /// Int.
    var int: Int {
        return Int(self)
    }
    
    /// Double.
    var double: Double {
        return Double(self)
    }
    
    /// CGFloat.
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension FloatingPoint {
    
    /// Absolute value of number.
    var abs: Self {
        return Swift.abs(self)
    }
    
    /// Check if number is positive.
    var isPositive: Bool {
        return self > 0
    }
    
    /// Check if number is negative.
    var isNegative: Bool {
        return self < 0
    }
    
    /// Ceil of number.
    var ceil: Self {
        return Foundation.ceil(self)
    }
    
    /// Radian value of degree input.
    var degreesToRadians: Self {
        return Self.pi * self / Self(180)
    }
    
    /// Floor of number.
    var floor: Self {
        return Foundation.floor(self)
    }
    
    /// Degree value of radian input.
    var radiansToDegrees: Self {
        return self * Self(180) / Self.pi
    }
}
