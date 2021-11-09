//
//  StringExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/2.
//

import Foundation
import UIKit

// MARK: - 计算字符串的宽高
public extension String {
    
    func boundingRect(font: UIFont, limitSize: CGSize) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let att = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]
        let attContent = NSMutableAttributedString(string: self, attributes: att)
        let size = attContent.boundingRect(with: limitSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    /// 获取字符串绘制高度
    ///
    /// - Parameters:
    ///   - width: 绘制区域宽度
    ///   - font: 绘制字体
    /// - Returns: 绘制的高度
    func drawHeight(with width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        let rect = (self as NSString).boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil)
        return ceil(rect.height) + 1
    }
    
    /// 获取字符串单行绘制宽度
    ///
    /// - Parameter font: 字体
    /// - Returns: 返回宽度
    func drawWidth(with font: UIFont) -> CGFloat {
        
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: font.lineHeight)
        let rect = (self as NSString).boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil)
        return ceil(rect.width) + 1
    }
    
    func drawSize(_ font: UIFont) -> CGSize {
        let size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let rect = (self as NSString).boundingRect(with: size, options: [.usesFontLeading,.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil)
        let ceilW = CGFloat(ceil(rect.size.width))
        let ceilH = CGFloat(ceil(rect.size.height)) + 4
        return CGSize(width: ceilW, height: ceilH)
    }
}

// MARK: - 属性
public extension String {
    
    enum RsError: Error {
        case hexStringToDataOverflowoutCharacter
        case irregularHexString
    }
    
    /// 将十六进制字符串转为数据流
    ///
    /// - Returns: 数据流
    /// - Throws: 字符串存在非十六进制字符错误
    func hexStringToData() throws -> Data {
        var data = Data()
        var temp = self.replacingOccurrences(of: "/n", with: "")
        temp = temp.replacingOccurrences(of: "/r", with: "")
        temp = temp.replacingOccurrences(of: " ", with: "")
        for i in 0..<temp.count/2 {
            let sub = (temp as NSString).substring(with: NSRange.init(location: 2*i, length: 2))
            if let result = UInt8(sub,radix: 16) {
                data.append(result)
            }else {
                throw RsError.hexStringToDataOverflowoutCharacter
            }
        }
        return data
    }
    
    //是否是规则的十六进制字符串，"12 54 ef"格式
    var isRegularHexString: Bool {
        let regularString = "^[ \\n\\r]*([0-9a-fA-F]{2}[ \\n\\r]+)*([0-9a-fA-F]{2})*$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", regularString)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNo: Bool {
        let pattern = "^((1[389][0-9])|(14[579])|(15[0-3,5-9])|(16[2567])|(17[0-8]))\\d{8}$"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    var isIp: Bool {
        let numPre = "(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)"
        let rex = String.init(format: "^(%@.){3}%@$", numPre, numPre)
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", rex)
        return predicate.evaluate(with: self)
    }
    
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    var isValidEmail: Bool {
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// Check if string only contains digits.
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
            0x1D000...0x1F77F, // Emoticons
            0x2100...0x27BF, // Misc symbols and Dingbats
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    var base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
    
    var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    
    /// Check if string contains one or more numbers.
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// Check if string contains only letters.
    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }
    
    /// Check if string contains at least one letter and one number.
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    /// Check if string is a valid URL.
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    
    /// Check if string is a valid schemed URL.
    var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }
    
    /// Check if string is a valid http URL.
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    
    /// Check if string is a valid file URL.
    var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    
    /// Date object from "yyyy-MM-dd" formatted string.
    var date: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: selfLowercased)
    }
    
    /// Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    var dateTime: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: selfLowercased)
    }
    
    /// Integer value from string (if applicable).
    var int: Int? {
        return Int(self)
    }
    
    /// URL from string (if applicable).
    var url: URL? {
        return URL(string: self)
    }
}

//MARK: - 加密（md5 sha1）
public extension String {
    
    var md5: String {
        
        return self.data(using: .utf8)!.md5
    }
    
    var sha1: String {
        
        return self.data(using: .utf8)!.sha1
    }
}

// MARK: - 方法
public extension String {
    
    func filterLines() -> String {
        self.filter({ $0 != "\n"})
    }
    
    func calculateLines() -> Int {
        var count = 0
        return self.reduce(0, {
            if $1 == "\n" {
                count = $0 + 1
            }
            return count
        })
    }
    
    func filterInvaildCharacter() -> String {
        let predicateStr: String = "^[A-Za-z0-9-_:. ]{1}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return self.filter({ predicate.evaluate(with: String($0)) })
    }
    
    func filterNoDigits() -> String {
        let predicateStr: String = "^[0-9.]{1}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", predicateStr)
        return self.filter({ predicate.evaluate(with: String($0)) })
    }
    
    func subStringFrom(pos: Int) -> String {
        var substr = ""
        let start = self.index(self.startIndex, offsetBy: pos)//self.startIndex.advancedBy(pos)
        let end = self.endIndex

        let range = start..<end
        substr = String(self[range])
        return substr
    }
    
    func subStringTo(pos:Int) -> String {
        var substr = ""
        let end = self.index(self.startIndex, offsetBy: pos - 1)
        let range = self.startIndex...end
        substr = String(self[range])
        return substr
    }
    
    ///  "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    func words() -> [String] {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    
    /// "Hello\ntest".lines() -> ["Hello", "test"]
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    
    /// Random string of given length.
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }
    
    mutating func reverse() {
        let chars: [Character] = reversed()
        self = String(chars)
    }
    
    /// Sliced string from a start index with length.
    ///
    /// "Hello World".slicing(from: 6, length: 5) -> "World"
    func slicing(from i: Int, length: Int) -> String? {
        guard length >= 0, i >= 0, i < count  else { return nil }
        guard i.advanced(by: length) <= count else {
            return self[safe: i..<count]
        }
        guard length > 0 else { return "" }
        return self[safe: i..<i.advanced(by: length)]
    }
    
    /// Slice given string from a start index with length (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, length: 5)
    ///        print(str) // prints "World"
    ///
    mutating func slice(from i: Int, length: Int) {
        if let str = slicing(from: i, length: length) {
            self = String(str)
        }
    }
    
    /// Slice given string from a start index to an end index (if applicable).
    ///
    ///        var str = "Hello World"
    ///        str.slice(from: 6, to: 11)
    ///        print(str) // prints "World"
    ///
    mutating func slice(from start: Int, to end: Int) {
        guard end >= start else { return }
        if let str = self[safe: start..<end] {
            self = str
        }
    }
    
    mutating func slice(at i: Int) {
        guard i < count else { return }
        if let str = self[safe: i..<count] {
            self = str
        }
    }
    
    /// Safely subscript string with index.
    ///
    ///        "Hello World!"[safe: 3] -> "l"
    ///        "Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter i: index.
    // swiftlint:disable:next identifier_name
    subscript(safe i: Int) -> Character? {
        guard i >= 0 && i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }
    
    // Safely subscript string within a half-open range.
    ///
    ///        "Hello World!"[safe: 6..<11] -> "World"
    ///        "Hello World!"[safe: 21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Safely subscript string within a closed range.
    ///
    ///        "Hello World!"[safe: 6...11] -> "World!"
    ///        "Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
}


// MARK: - NSString extensions
public extension String {

    /// NSString from a string.
    var nsString: NSString {
        return NSString(string: self)
    }

    /// NSString lastPathComponent.
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    /// NSString pathExtension.
    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    /// NSString deletingLastPathComponent.
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }

    /// NSString deletingPathExtension.
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }

    /// : NSString pathComponents.
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    /// NSString appendingPathComponent(str: String)
    ///
    /// - Parameter str: the path component to append to the receiver.
    /// - Returns: a new string made by appending aString to the receiver, preceded if necessary by a path separator.
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    /// NSString appendingPathExtension(str: String)
    ///
    /// - Parameter str: The extension to append to the receiver.
    /// - Returns: a new string made by appending to the receiver an extension separator followed by ext (if applicable).
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
}

extension String {
    
    static func zeroValue(_ value: String) -> String {
        var testNumber = value
        let range = (testNumber as NSString).range(of: ".") //现获取要截取的字符串位置
        
        if range.length > 0 {
            var s: String? = nil
            var offset = testNumber.count - 1
            while offset > 0 {
                s = (testNumber as NSString).substring(with: NSRange(location: offset, length: 1))
                if offset >= range.location && ((s == "0") || (s == ".")) {
                    offset -= 1
                } else {
                    break
                }
            }
            testNumber = (testNumber as NSString).substring(to: offset + 1)
        }
        return testNumber
    }
    
    static func mileageValue(_ value: Double) -> String {
        if value < 999.0{
            return "\(String.zeroValue(String(format: "%.3f", value)))mm"
        }else{
            return "\(String.zeroValue(String(format: "%.3f", value/1000.0)))m"
        }
    }
}

//MARK: 国际化协议
public protocol LocalizedBundle {
    var localized: String { get }
}

extension String : LocalizedBundle {
    
    public var localized: String {
        return localized(using: nil, in: .main)
    }
    
    private func localized(using tableName: String?, in bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: Localize.language.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }else if let path = bundle.path(forResource: "Base", ofType: "lproj"),
                 let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }
}


