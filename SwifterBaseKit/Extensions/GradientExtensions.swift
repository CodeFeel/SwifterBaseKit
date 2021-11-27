//
//  GradientExtensions.swift
//  SwifterBaseKit
//
//  Created by ios on 2021/11/27.
//

import Foundation
import UIKit

 public extension CAGradientLayer {
    
    func generateGradientLayer(_ cgColors: [CGColor], locations: [NSNumber]) {
        self.colors = cgColors
        self.locations = locations
        self.startPoint = CGPoint(x: 0, y: 0)
        self.endPoint = CGPoint(x: 0, y: 1)
    }
    
    convenience init(_ colors: [CGColor], locations: [NSNumber], start: CGPoint, end: CGPoint) {
        self.init()
        self.colors = colors
        self.locations = locations
        self.startPoint = start
        self.endPoint = end
    }
}
