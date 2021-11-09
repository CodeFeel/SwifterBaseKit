//
//  ImageExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/3.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// Size in bytes of UIImage
    var bytesSize: Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// Size in kilo bytes of UIImage
    var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
    var pixelWidth: CGFloat {
        return size.width*scale
    }
    
    var pixelHeight: CGFloat {
        return size.height*scale
    }
    
    var hasAlpha: Bool {
        if let cgImage = cgImage {
            switch cgImage.alphaInfo {
                case .none, .noneSkipLast, .noneSkipFirst:
                    return false
                default:
                    return true
            }
        }else {
            return true
        }
    }
}

public extension UIImage {
    
    /// 图片剪切
    /// - Parameter pixelRect: 截切位置大小
    /// - Returns: 剪切结果
    func cropped(to pixelRect: CGRect) -> UIImage {
        let rect = CGRect(x: floor(pixelRect.origin.x),
                          y: floor(pixelRect.origin.y),
                          width: floor(pixelRect.width),
                          height: floor(pixelRect.height))
        let scaledRect = rect.applying(CGAffineTransform(scaleX: scale, y: scale))
        guard let image = cgImage?.cropping(to: scaledRect) else { return self }
        return UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
    }
    
    /// 将图片剪切至某个宽高比，取出中间部分
    ///
    /// - Parameter aspectRatio: 宽高比
    /// - Returns: 剪切结果
    func crop(aspectRatio: CGFloat) -> UIImage {
        
        let imageAspectRatio = pixelWidth/pixelHeight
        if imageAspectRatio == aspectRatio {
            return self
        }
        var contentRect = CGRect.zero
        if imageAspectRatio > aspectRatio {
            contentRect.size.height = pixelHeight
            contentRect.size.width = pixelHeight*aspectRatio
        }else {
            contentRect.size.width = pixelWidth
            contentRect.size.height = pixelWidth/aspectRatio
        }
        contentRect.origin.x = (pixelWidth - contentRect.width)/2
        contentRect.origin.y = (pixelHeight - contentRect.height)/2
        return cropped(to: contentRect)
    }
    
    /// 修改图片大小
    ///
    /// - Parameter size: 修改的大小
    /// - Returns: 修改后图片
    func resize(size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    /// 将图片旋转90度
    ///
    /// - Parameter clockwise: 是否顺时针旋转
    /// - Returns: 旋转后图片
    func rotate90(clockwise: Bool) -> UIImage {
        
        let size = CGSize.init(width: pixelHeight, height: pixelWidth)
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        let ctx = UIGraphicsGetCurrentContext()!
        if clockwise {
            ctx.translateBy(x: size.width, y: 0)
            ctx.rotate(by: CGFloat.pi/2)
        }else {
            ctx.translateBy(x: 0, y: size.height)
            ctx.rotate(by: -CGFloat.pi/2)
        }
        draw(in: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: pixelWidth, height: pixelHeight)))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    /// UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    /// Creates a copy of the receiver rotated by the given angle.
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: Measurement(value: 180, unit: .degrees))
    ///
    /// - Parameter angle: The angle measurement by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    @available(iOS 10.0, tvOS 10.0, watchOS 3.0, *)
    func rotated(by angle: Measurement<UnitAngle>) -> UIImage? {
        let radians = CGFloat(angle.converted(to: .radians).value)
        
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Creates a copy of the receiver rotated by the given angle (in radians).
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: The angle, in radians, by which to rotate the image.
    /// - Returns: A new image rotated by the given angle.
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())
        
        UIGraphicsBeginImageContext(roundedDestRect.size)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }
        
        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)
        
        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    /// 将图片填充到某个宽高比的单色背景图片，居中填充，填充时保留原图片的宽高比
    ///
    /// - Parameters:
    ///   - aspectRatio: 结果图片宽高比
    ///   - color: 背景颜色，默认白色
    /// - Returns: 填充后的图片
    func fillIn(aspectRatio: CGFloat, background color: UIColor = UIColor.white) -> UIImage {
        
        if pixelWidth/pixelHeight == aspectRatio {
            return self
        }
        var size = CGSize.zero
        if pixelWidth/pixelHeight > aspectRatio {
            size.width = pixelWidth
            size.height = pixelWidth/aspectRatio
        }else {
            size.height = pixelHeight
            size.width = pixelHeight*aspectRatio
        }
        let insetX = (size.width - pixelWidth)/2
        let insetY = (size.height - pixelHeight)/2
        var drawRect = CGRect.init(origin: CGPoint.zero, size: size)
        drawRect = drawRect.insetBy(dx: insetX, dy: insetY)
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        color.setFill()
        UIRectFill(CGRect.init(origin: CGPoint.zero, size: size))
        draw(in: drawRect)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    /// 将原图分别绘制到指定区域
    ///
    /// - Parameters:
    ///   - size: 结果图片大小
    ///   - rects: 绘制区域数组
    ///   - color: 背景色
    ///   - extraDrawClosure: 额外的绘制closure
    /// - Returns: 绘制结果
    func drawIn(
        destination size: CGSize,
        rects:[CGRect],
        background color: UIColor = UIColor.white,
        extraDrawClosure: ((_: CGContext) -> Void)? = nil)
    -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect.init(origin: CGPoint.zero, size: size))
        for rect in rects {
            draw(in: rect)
        }
        let ctx = UIGraphicsGetCurrentContext()!
        extraDrawClosure?(ctx)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    /// Compressed UIImage from original UIImage.
    func compressed(quality: CGFloat = 0.1) -> UIImage? {
        guard let data = compressedData(quality: quality) else { return nil }
        return UIImage(data: data)
    }
    
    /// Compressed UIImage data from original UIImage.
    func compressedData(quality: CGFloat = 0.1) -> Data? {
        return jpegData(compressionQuality: quality)
    }
    
    /// UIImage with rounded corners
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    /// 旋转图片
    func rotateAngle(_ angle: CGFloat) -> UIImage {
        
        if angle.truncatingRemainder(dividingBy: 360) == 0 { return self }
        let imageRect = CGRect(origin: .zero, size: self.size)
        let radian = CGFloat(angle / 180 * CGFloat.pi)
        let rotatedTransform = CGAffineTransform.identity.rotated(by: radian)
        var rotatedRect = imageRect.applying(rotatedTransform)
        rotatedRect.origin.x = 0
        rotatedRect.origin.y = 0
        
        UIGraphicsBeginImageContextWithOptions(rotatedRect.size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: rotatedRect.width / 2, y: rotatedRect.height / 2)
        context.rotate(by: radian)
        context.translateBy(x: -self.size.width / 2, y: -self.size.height / 2)
        draw(at: .zero)
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}

public extension UIImage {
    
    /// Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
}
