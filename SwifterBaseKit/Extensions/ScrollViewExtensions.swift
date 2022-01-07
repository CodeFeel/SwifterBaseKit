//
//  ScrollViewExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/3.
//

import Foundation
import UIKit

public extension UIScrollView {
    
    /// UIGraphics
    var snapshot: UIImage? {
        
        autoreleasepool {
            let lastContentOffset = self.contentOffset
            let lastFrame = self.frame
            self.contentOffset = .zero
            self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: self.contentSize.width, height: floor(self.contentSize.height)), false, 0)
            defer {
                self.contentOffset = lastContentOffset
                self.frame = lastFrame
                UIGraphicsEndImageContext()
            }
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    
    /// CoreGraphics
    var longSnapshotImage: UIImage? {
        var resultImage = UIImage()
        let lastContentOffset = self.contentOffset
        let lastFrame = self.frame
        self.contentOffset = .zero
        self.frame = CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height)
        
        let imageBuffer = malloc(4 * Int(ceil(self.contentSize.width)) * Int(ceil(self.contentSize.height)))
        
        if let context = CGContext.init(data: imageBuffer, width: Int(ceil(self.contentSize.width)), height: Int(ceil(self.contentSize.height)), bitsPerComponent: 8, bytesPerRow: Int(ceil(self.contentSize.width)) * 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            context.translateBy(x: 0, y: self.contentSize.height)
            context.scaleBy(x: 1.0, y: -1.0)
            layer.render(in: context)
            if let cgImage = context.makeImage() {
                resultImage =  UIImage(cgImage: cgImage)
            }
        }
        free(imageBuffer)
        return resultImage
    }
    
}

public extension UIScrollView {
    
    /// 获取长截图
    func getLongSnapshotImage(_ completionHandler: @escaping (_ screenShotImage: UIImage?) -> Void) {
        
        self.isShoting = true
        self.backgroundColor = UIColor.white
        // Put a fake Cover of View
        let snapShotView = self.snapshotView(afterScreenUpdates: true)
        snapShotView?.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (snapShotView?.frame.size.width)!, height: (snapShotView?.frame.size.height)!)
        self.superview?.addSubview(snapShotView!)
        
        // Backup
        let bakOffset    = self.contentOffset
        // Divide
        let page  = floorf(Float(self.contentSize.height / self.bounds.height))
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, 0.0)
        self.scrollPageDraw(0, maxIndex: Int(page), drawCallback: { [unowned self] () -> Void in
            let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Recover
            self.setContentOffset(bakOffset, animated: false)
            snapShotView?.removeFromSuperview()
            self.backgroundColor = UIColor.color(hexString: "#F6F6F6")
            self.isShoting = false
            completionHandler(screenShotImage)
        })
    }
    
    fileprivate func scrollPageDraw(_ index: Int, maxIndex: Int, drawCallback: @escaping () -> Void) {
        
        self.setContentOffset(CGPoint(x: 0, y: CGFloat(index) * floor(self.frame.size.height)), animated: false)
        let splitFrame = CGRect(x: 0, y: CGFloat(index) * floor(self.frame.size.height), width: bounds.size.width, height: floor(bounds.size.height))
        Asyncs.delay(0.3) {
            self.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            if index < maxIndex {
                self.scrollPageDraw(index + 1, maxIndex: maxIndex, drawCallback: drawCallback)
            }else{
                drawCallback()
            }
        }
    }
    
    
}
