//
//  DataExtensions.swift
//  RedSwift
//
//  Created by ios on 2021/11/2.
//

import Foundation
import CommonCrypto

public extension Data {
    
    var md5: String {
        return encryptionString(type: .md5)
    }
    
    var sha1: String {
        return encryptionString(type: .sha1)
    }
    
    private enum Encryption {
        case md5, sha1
    }
    
    private func encryptionString(type: Encryption) -> String {
        
        var length: Int
        switch type {
        case .md5:
            length = Int(CC_MD5_DIGEST_LENGTH)
        case .sha1:
            length = Int(CC_SHA1_DIGEST_LENGTH)
        }
        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
        switch type {
        case .md5:
            _ = CC_MD5((self as NSData).bytes, CC_LONG.init(self.count), digest)
        case .sha1:
            _ = CC_SHA1((self as NSData).bytes, CC_LONG.init(self.count), digest)
        }
        let digestData = Data.init(bytes: digest, count: length)
        return digestData.hex.joined()
    }
}

//MARK: - 16进制
public extension Data {
    
    /// 对应的十六进制字符串，每个字节转为两个十六进制字符，字节间用空格隔开
    var hexString: String  {
        return hex.joined(separator: " ")
    }
    
    var hex: [String] {
        return self.map({String.init(format: "%02x", $0)})
    }
    
    // BOM:
    // 00 00 fe ff  utf32-BE
    // ff fe 00 00  utf32-LE
    // ef bb bf     utf8
    // fe ff        utf16-BE
    // ff fe        utf16-LE
    // without BOM  utf8
    var txt: String? {
        
        var content = self
        var encoding = String.Encoding.utf8
        if count >= 4 {
            switch (self[0], self[1], self[2], self[3]) {
            case (0x0, 0x0, 0xfe, 0xff):
                content.removeSubrange(0..<4)
                encoding = .utf32BigEndian
            case (0xff, 0xfe, 0x0, 0x0):
                content.removeSubrange(0..<4)
                encoding = .utf32LittleEndian
            case (0xef, 0xbb, 0xbf, _):
                content.removeSubrange(0..<3)
                encoding = .utf8
            case (0xfe, 0xff, _, _):
                content.removeSubrange(0..<2)
                encoding = .utf16BigEndian
            case (0xff, 0xfe, _, _):
                content.removeSubrange(0..<2)
                encoding = .utf16LittleEndian
            default:
                break
            }
        }else if count >= 2 {
            switch (self[0], self[1]) {
            case (0xef, 0xbb):
                if count >= 3 && self[2] == 0xbf {
                    content.removeSubrange(0..<3)
                }
            case (0xfe, 0xff):
                content.removeSubrange(0..<2)
                encoding = .utf16BigEndian
            case (0xff, 0xfe):
                content.removeSubrange(0..<2)
                encoding = .utf16LittleEndian
            default:
                break
            }
        }
        if let txt = String.init(data: content, encoding: encoding) {
            return txt
        }else {
            return nil
        }
    }
    
    /// Return data as an array of bytes.
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}

public extension Data {
    
    /// String by encoding Data using the given encoding (if applicable).
    func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    /// Returns a Foundation object from given JSON data.
    ///
    /// - Parameter options: Options for reading the JSON data and creating the Foundation object.
    ///
    ///   For possible values, see `JSONSerialization.ReadingOptions`.
    /// - Returns: A Foundation object from the JSON data in the receiver, or `nil` if an error occurs.
    /// - Throws: An `NSError` if the receiver does not represent a valid JSON object.
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
    
    static func create<T>(_ value: T, as type: T.Type) -> Data {
        
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        pointer.pointee = value
        let data = Data.init(bytes: UnsafeRawPointer(pointer), count: MemoryLayout<T>.stride)
        pointer.deallocate()
        return data
    }
    
    mutating func append<T>(_ value: T, as type: T.Type) -> Void {
        
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        pointer.pointee = value
        let raw = pointer.withMemoryRebound(to: UInt8.self, capacity: 1) { $0 }
        append(raw, count: MemoryLayout<T>.stride)
        pointer.deallocate()
    }
    
    mutating func storeBytes<T>(_ value: T, toByteOffset offset: Int = 0, as type: T.Type) {
        
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        pointer.pointee = value
        let size = MemoryLayout<T>.stride
        replaceSubrange(offset..<offset + size, with: UnsafePointer(pointer), count: size)
        pointer.deallocate()
    }
    
    func readValue<T>(offset: Int = 0, as type: T.Type) -> T? {
        
        guard offset >= 0 else { return nil }
        let size = MemoryLayout<T>.stride
        if offset + size > count {
            return nil
        }
        let bytes = (self as NSData).bytes + offset
        let pointer = bytes.bindMemory(to: type, capacity: 1)
        return pointer.pointee
    }
}
