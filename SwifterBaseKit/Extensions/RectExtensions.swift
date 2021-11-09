//
//  RectExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/3.
//

import Foundation
import UIKit

public extension CGRect {
    
    func contentRect(ratio: CGFloat, margin: CGFloat = 0) -> CGRect {
        let tempFrame = self.insetBy(dx: margin, dy: margin)
        
        if tempFrame.width/tempFrame.height > ratio {
            let contentWidth = ratio*tempFrame.height
            let result = tempFrame.insetBy(dx: (tempFrame.width - contentWidth)/2, dy: 0)
            return result
        }else {
            let contentHeight = tempFrame.width/ratio
            let result = tempFrame.insetBy(dx: 0, dy: (tempFrame.height - contentHeight)/2)
            return result
        }
    }
    
    func insetBy(edgeInset: UIEdgeInsets) -> CGRect {
        return CGRect.init(x: self.origin.x + edgeInset.left,
                           y: self.origin.y + edgeInset.top,
                           width: self.size.width - edgeInset.left - edgeInset.right,
                           height: self.size.height - edgeInset.top - edgeInset.bottom)
    }
}

public extension CGRect {
    
    static func / (lhs: CGRect, scalar: CGFloat) -> CGRect {
        return CGRect.init(x: lhs.origin.x / scalar,
                           y: lhs.origin.y / scalar,
                           width: lhs.width / scalar,
                           height: lhs.height / scalar)
    }

    static func * (lhs: CGRect, scalar: CGFloat) -> CGRect {
        return CGRect.init(x: lhs.origin.x * scalar,
                           y: lhs.origin.y * scalar,
                           width: lhs.width * scalar,
                           height: lhs.height * scalar)
    }
    
    
    
}
