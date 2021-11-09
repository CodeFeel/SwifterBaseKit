//
//  UserDefaultsExtensions.swift
//  RedSwift_Example
//
//  Created by ios on 2021/11/2.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

public protocol UD {
    
    associatedtype Element
    var namespace: String { get }
    func save(_ value: Element?) -> Void
    var value: Element? { get }
}

public extension UD {
    
    var namespace: String {
        return "\(type(of: self)).\(self)".md5
    }
    
    func save(_ value: Element?) -> Void {
        UserDefaults.standard.set(value, forKey: namespace)
        UserDefaults.standard.synchronize()
    }
    
    var value: Element? {
        return UserDefaults.standard.value(forKey: namespace) as? Element
    }
    
    func remove() -> Void {
        UserDefaults.standard.removeObject(forKey: namespace)
    }
}
