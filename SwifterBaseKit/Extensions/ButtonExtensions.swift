//
//  ButtonExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/3.
//

import Foundation
import UIKit

public extension UIButton {
    
    /// Image of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }
    
    /// Image of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }
    
    /// Image of normal state for button; also inspectable from Storyboard.
    @IBInspectable var imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    /// Image of selected state for button; also inspectable from Storyboard.
    @IBInspectable var imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }
    
    /// Title color of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }
    
    /// Title color of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }
    
    /// Title color of normal state for button; also inspectable from Storyboard.
    @IBInspectable var titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    /// Title color of selected state for button; also inspectable from Storyboard.
    @IBInspectable var titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }
    
    /// Title of disabled state for button; also inspectable from Storyboard.
    @IBInspectable var titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }
    
    /// Title of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable var titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }
    
    /// Title of normal state for button; also inspectable from Storyboard.
    @IBInspectable var titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    /// Title of selected state for button; also inspectable from Storyboard.
    @IBInspectable var titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }
}

public extension UIButton {
    
    /// Center align title text and image on UIButton
    ///
    /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
    // 图片文字垂直排列，并居中
    func layoutImageTitleVerticallyCenter(contentSpace space: CGFloat) -> Void {
        
        guard let imageSize = imageView?.bounds.size else { return }
        guard let titleSize = titleLabel?.bounds.size else { return }
        imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height + space)/2, left: titleSize.width/2, bottom: (titleSize.height + space)/2, right: -(titleSize.width)/2)
        titleEdgeInsets = UIEdgeInsets.init(top: (imageSize.height + space)/2, left: -(imageSize.width)/2, bottom: -(imageSize.height + space)/2, right: imageSize.width/2)
    }
    // 图片文字水平排列，并整体居中
    func layoutImageTitleHolizontallyCenter(contentSpace space : CGFloat) -> Void {
        
        imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -space/2, bottom: 0, right: space/2)
        titleEdgeInsets = UIEdgeInsets.init(top: 0, left: space/2, bottom: 0, right: -space/2)
    }
    
    // 图片文字水平排列，并整体居中,图片在左，文字在右，与默认相反
    func layoutImageTitleHolizontallyCenterReverse(contentSpace space : CGFloat) -> Void {
        
        guard let imageSize = imageView?.bounds.size else { return }
        guard let titleSize = titleLabel?.bounds.size else { return }
        imageEdgeInsets = UIEdgeInsets.init(top: 0, left: titleSize.width + space/2, bottom: 0, right: -(titleSize.width + space/2))
        titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(imageSize.width + space/2), bottom: 0, right: imageSize.width + space/2)
    }
    // 图片文字水平排列，并整体居左
    func layoutImageTitleHolizontallyLeft(contentSpace space : CGFloat) -> Void {
        
        guard let imageSize = imageView?.bounds.size else { return }
        guard let titleSize = titleLabel?.bounds.size else { return }
        imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -(self.bounds.width - imageSize.width - titleSize.width)/2, bottom: 0, right: (bounds.width - imageSize.width - titleSize.width)/2)
        titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(bounds.width - imageSize.width - titleSize.width)/2 + space, bottom: 0, right: (bounds.width - imageSize.width - titleSize.width)/2 - space)
    }
    // 图片文字水平排列，文字h居左，图片居右，并设置左右边距
    func layoutTitleImageHorizonal(leftMargin: CGFloat, rightMargin: CGFloat) -> Void {
        
        guard let imageSize = imageView?.bounds.size else { return }
        guard let titleSize = titleLabel?.bounds.size else { return }

        let contentWidth = imageSize.width + titleSize.width
        let leftOrRightSpaceWidth = (bounds.width - contentWidth)/2
        let titleOffsetX = leftOrRightSpaceWidth + imageSize.width - leftMargin
        let imageOffsetX = leftOrRightSpaceWidth + titleSize.width - rightMargin
        imageEdgeInsets = UIEdgeInsets.init(top: 0, left: imageOffsetX, bottom: 0, right: -imageOffsetX)
        titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -titleOffsetX, bottom: 0, right: titleOffsetX)
    }
    
    /** 图片右 文字左 */
    func setIconInRightWithSpacing(_ space: CGFloat) -> Void {
        guard let imgW = self.imageView?.frame.size.width else { return }
        guard let tilW = self.titleLabel?.frame.size.width else { return }
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imgW - space, bottom: 0, right: imgW + space)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: tilW + space, bottom: 0, right: -tilW - space)
    }
}
