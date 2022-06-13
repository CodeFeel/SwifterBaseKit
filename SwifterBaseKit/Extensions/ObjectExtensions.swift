//
//  ObjectExtensions.swift
//  SwifterBaseKit
//
//  Created by ios on 2022/6/13.
//

import Foundation

public extension NSObject {
    
    static var className: String { String.init(describing: self) }
}
