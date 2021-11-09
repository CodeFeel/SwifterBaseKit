//
//  Global.swift
//  RedSwift
//
//  Created by ios on 2021/11/5.
//

import Foundation
import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenScale = UIScreen.main.scale
let kAppWindow = UIApplication.shared.delegate!.window!!
let kLastWindow = UIApplication.shared.windows.last!

let kReferenceW = kScreenWidth / 375.0
let kReferenceH = kScreenHeight / 667.0

/// 状态栏高度
var kScreenStatusHeight : CGFloat {
    if #available(iOS 13.0, *) {
        return UIApplication.shared.statusBarFrame.height
    }
    return UIApplication.shared.statusBarFrame.height
}

/// 导航栏高度
let kSafeAreaTopHeight : CGFloat = Int(kScreenStatusHeight) > 20 ? 88.0 : 64.0
/// tab高度
let kTabBarHeight: CGFloat = Int(kScreenStatusHeight) > 20 ? 83 : 49
/// tab距离底部高度
let kSafeAreaBottomHeight: CGFloat = Int(kScreenStatusHeight) > 20 ? 34 : 0

/// 沙盒路径
public struct kDirectoryPath {
    static let Home = NSHomeDirectory()
    static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).last!
    static let Library = NSSearchPathForDirectoriesInDomains(.libraryDirectory,.userDomainMask, true).last!
    static let Tmp = NSTemporaryDirectory()
    static let Caches = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask, true).last!
}

/// 版本信息
public struct kAppInfo {
    public static var version = { Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String }()
    public static var bundleId = { Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String }()
    public static var displayName = { Bundle.main.localizedInfoDictionary!["CFBundleDisplayName"] as! String }()
    public static var kUUID =  UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: "")
    public static var systemVersion = UIDevice.current.systemVersion
}

public func TLog<T>(message:T) -> Void {
#if DEBUG
    print("\(message)")
#endif
}

public func TMoreLog<T>(message:T, file:String=#file, method:String=#function,line:Int=#line) {
#if DEBUG
    print("[\(file):\(method):\(line))]--\(message)")
#endif
}



