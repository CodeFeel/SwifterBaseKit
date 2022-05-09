//
//  Localize.swift
//  RedSwift
//
//  Created by ios on 2021/11/6.
//

import Foundation

public enum LanguageType : String {
    case zh_Hans    = "zh-Hans"
    case zh_Hant    = "zh-Hant"
    case en         = "en"
    /// 日本语
    case ja         = "ja"
    /// 韩语
    case ko         = "ko"
    /// 法语
    case fr         = "fr"
    /// 意大利语
    case it         = "it"
    /// 西班牙语
    case es         = "es"
    /// 波兰语
    case pl         = "pl"
    /// 捷克
    case cs         = "cs"
    /// 德语
    case de         = "de"
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
        
        guard let prefixLanguage = Locale.preferredLanguages.first else {
            return defaultLanguage
        }
        guard var preferredLanguage = prefixLanguage.components(separatedBy: "-").first else {
            return defaultLanguage
        }
        /// 这边处理简体和繁体
        if preferredLanguage == "zh" {
            if prefixLanguage.contains("zh-Hans") {
                preferredLanguage = "zh-Hans"
            }else {
                preferredLanguage = "zh-Hant"
            }
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
