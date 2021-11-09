//
//  IntExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/6.
//

import Foundation
import CoreGraphics

public extension SignedInteger {
    var abs: Self {
        return Swift.abs(self)
    }
}
    
public extension Int {
    
    /// CountableRange 0..<Int.
    var countableRange: CountableRange<Int> {
        return 0..<self
    }

    /// Radian value of degree input.
     var degreesToRadians: Double {
        return Double.pi * Double(self) / 180.0
    }

    /// Degree value of radian input
     var radiansToDegrees: Double {
        return Double(self) * 180 / Double.pi
    }

    /// UInt.
     var uInt: UInt {
        return UInt(self)
    }

    /// Double.
     var double: Double {
        return Double(self)
    }

    /// Float.
     var float: Float {
        return Float(self)
    }

    /// CGFloat.
     var cgFloat: CGFloat {
        return CGFloat(self)
    }

    /// String formatted for values over ±1000 (example: 1k, -2k, 100k, 1kk, -5kk..)
     var kFormatted: String {
        var sign: String {
            return self >= 0 ? "" : "-"
        }
        let abs = Swift.abs(self)
        if abs == 0 {
            return "0k"
        } else if abs >= 0 && abs < 1000 {
            return "0k"
        } else if abs >= 1000 && abs < 1000000 {
            return String(format: "\(sign)%ik", abs / 1000)
        }
        return String(format: "\(sign)%ikk", abs / 100000)
    }

    /// Array of digits of integer value.
     var digits: [Int] {
        guard self != 0 else { return [0] }
        var digits = [Int]()
        var number = abs

        while number != 0 {
            let xNumber = number % 10
            digits.append(xNumber)
            number /= 10
        }

        digits.reverse()
        return digits
    }

    /// Number of digits of integer value.
     var digitsCount: Int {
        guard self != 0 else { return 1 }
        let number = Double(abs)
        return Int(log10(number) + 1)
    }
}
