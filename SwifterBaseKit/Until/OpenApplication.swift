//
//  OpenApplication.swift
//  RedSwift
//
//  Created by ios on 2021/11/6.
//

import Foundation
import UIKit

public struct OpenApplication {
    
    public static func open(_ url: String, _ failure: (() -> Void)) {
        /// 这边需要转义下地址，url允许存在字符A-Z a-z 0-9 -_.~!*();:@&=+$,/?#[]
        if let temp = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            guard let tmallUrl = URL.init(string: temp), UIApplication.shared.canOpenURL(tmallUrl) else {
                failure()
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(tmallUrl, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(tmallUrl)
            }
        }else {
            failure()
        }
    }
}
