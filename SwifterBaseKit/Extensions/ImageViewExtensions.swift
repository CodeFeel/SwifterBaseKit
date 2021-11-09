//
//  ImageViewExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/3.
//

import Foundation
import UIKit
import Photos

public extension UIImageView {
    
    /// Set image from a URL.
    ///
    /// - Parameters:
    ///   - url: URL of image.
    ///   - contentMode: imageView content mode (default is .scaleAspectFit).
    ///   - placeHolder: optional placeholder image
    ///   - completionHandler: optional completion handler to run when download finishs (default is nil).
    func download(
        from url: URL,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        placeholder: UIImage? = nil,
        completionHandler: ((UIImage?) -> Void)? = nil) {

        image = placeholder
        self.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async {
                self.image = image
                completionHandler?(image)
            }
            }.resume()
    }

    /// Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
     func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }

    /// Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }
    
    func getStickerOperationImageView(_ image: UIImage, padding: CGFloat, bgColor: UIColor) -> Void {
        self.frame = CGRect(x: 0, y: 0, width: padding*2, height: padding*2)
        self.image = image
        self.tintColor = .black
        self.backgroundColor = bgColor
        self.layer.cornerRadius = padding
        self.isUserInteractionEnabled = true
    }
    
    func loadImage(with asset: PHAsset) {
        self.loadImage(with: asset, targetSize: CGSize.init(width: self.bounds.width, height: self.bounds.height))
    }
    
    func loadImage(with asset: PHAsset,targetSize: CGSize) {
        let imageRequest = PHImageRequestOptions()
        imageRequest.resizeMode = .exact
        imageRequest.deliveryMode = .opportunistic
        imageRequest.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize * kScreenScale, contentMode: .aspectFill, options: imageRequest) { (requestImage, info) in
            self.image = requestImage
        }
    }
}
