//
//  Localize.swift
//  RedSwift
//
//  Created by ios on 2021/11/6.
//

import Foundation

public enum LanguageType : String {
    case zh_Hans    = "zh-Hans"
    case en         = "en"
    case ja         = "ja"
    case ko         = "ko"
}

public struct Localize {
    
    public static var language = LanguageType.en
    
    /// 获取后要设置下 这边用静态变量language
    public static func currentLanguage() -> String {
        /// 本地是否有存储，没有的话则用系统设置
        if let temp = Storage.Language.language.value {
            return temp
        }
        return defaultLanguage()
    }
    
    public static func setCurrentLanguage(_ type: String) {
        let selectedLanguage = availableLanguages().contains(type) ? type : defaultLanguage()
        if let temp = LanguageType.init(rawValue: selectedLanguage) {
            language = temp
        }
    }
    
    public static func defaultLanguage() -> String {
        
        var defaultLanguage = LanguageType.en.rawValue
        guard var preferredLanguage = Locale.current.identifier.components(separatedBy: "_").first else {
            return defaultLanguage
        }
        /// 将zh-Hant zh变成本地的zh-Hans
        if preferredLanguage == "zh-Hant" || preferredLanguage == "zh" {
            preferredLanguage = "zh-Hans"
        }
        let availableLanguages = self.availableLanguages()
        if (availableLanguages.contains(preferredLanguage)) {
            defaultLanguage = preferredLanguage
        }else {
            defaultLanguage = LanguageType.en.rawValue
        }
        return defaultLanguage
    }
    
    public static func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base") , excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }
}
