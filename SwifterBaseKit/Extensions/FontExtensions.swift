//
//  FontExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/3.
//

import Foundation
import UIKit

public extension UIFont {
    
    enum SymbolicTraits {
        case regular, medium, bold
    }
    
    /// 默认不加倍
    static func pingFang(size: CGFloat, traits: SymbolicTraits = .regular, isFit: Bool = true) -> UIFont {
        switch traits {
        case .regular:
                return UIFont.init(name: "PingFangSC-Regular", size: (isFit ? Fitsize.fit(size) : size)) ?? UIFont.systemFont(ofSize: (isFit ? Fitsize.fit(size) : size))
        case .medium:
            return UIFont.init(name: "PingFangSC-Medium", size: (isFit ? Fitsize.fit(size) : size)) ?? UIFont.systemFont(ofSize: (isFit ? Fitsize.fit(size) : size))
        case .bold:
            return UIFont.init(name: "PingFangSC-Semibold", size: (isFit ? Fitsize.fit(size) : size)) ?? UIFont.boldSystemFont(ofSize: (isFit ? Fitsize.fit(size) : size))
        }
    }
    
    static func dinalternate(size: CGFloat, traits: SymbolicTraits = .regular, isFit: Bool = true) -> UIFont {
        switch traits {
        case .regular:
                return UIFont.init(name: "DINAlternate-Regular", size: (isFit ? Fitsize.fit(size) : size)) ?? UIFont.systemFont(ofSize: (isFit ? Fitsize.fit(size) : size))
        case .medium:
            return UIFont.init(name: "DINAlternate-Medium", size: (isFit ? Fitsize.fit(size) : size)) ?? UIFont.systemFont(ofSize: (isFit ? Fitsize.fit(size) : size))
        case .bold:
            return UIFont.init(name: "DINAlternate-Semibold", size: (isFit ? Fitsize.fit(size) : size)) ?? UIFont.boldSystemFont(ofSize: (isFit ? Fitsize.fit(size) : size))
        }
    }
}
