//
//  Fitsize.swift
//  RedSwift
//
//  Created by ios on 2021/11/5.
//

import UIKit

/// 宽度比 高度比
public struct Fitsize {

    static private var scalar : CGFloat {
        return min(kReferenceW, kReferenceH)
    }
    
    public static func fit(_ val: CGFloat) -> CGFloat {
        (scalar * val).rounded()
    }
}
