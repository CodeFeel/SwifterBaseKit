//
//  FileHelper.swift
//  RedSwift
//
//  Created by ios on 2021/11/6.
//

import Foundation

public struct FileHelper {
    /// 创建文件目录、如果不存在目录会创建目录
    ///
    /// - Parameter atPath: 文件目录
    /// - Returns: 是否创建成功
    @discardableResult
    public static func createDirectory(atPath: String) -> Bool {
        let fileManager = FileManager.default
        let result = fileManager.fileExists(atPath: atPath)
        if result == false {
            do {
                try fileManager.createDirectory(atPath: atPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                return false
            }
            return true
        } else {
            return true
        }
    }
    
    /// 获取单个文件大小
    ///
    /// - Parameter atPath: 文件路径
    /// - Returns: 文件大小
    public static func fileSize(atPath: String) -> Float {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: atPath) else {
            return 0.0
        }
        do {
            let attr = try fileManager.attributesOfItem(atPath: atPath) as NSDictionary
            return Float(attr.fileSize())
        } catch {
            return 0.0
        }
    }
    
    /// 获取文件属性
    ///
    /// - Parameter atPath: 文件路径
    /// - Returns: 文件大小
    public static func fileAttr(atPath: String) -> NSDictionary? {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: atPath) else {
            return nil
        }
        do {
            let attr = try fileManager.attributesOfItem(atPath: atPath) as NSDictionary
            return attr
        } catch {
            return nil
        }
    }
    
    
    /// 获取文件夹的大小
    ///
    /// - Parameter atPath: 文件夹路径
    /// - Returns: 文件夹大小
    public static func forderSize(atPath: String) -> Float {
        
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: atPath) else {
            return 0.0
        }
        guard let childFilePaths = fileManager.subpaths(atPath: atPath) else {
            return 0.0
        }
        
        var fileSize: Float = 0
        for path in childFilePaths {
            let fileAbsoluePath = atPath + "/" + path
            if isDirectory(atPath: fileAbsoluePath) {
                fileSize += 0
            } else {
                fileSize += FileHelper.fileSize(atPath: fileAbsoluePath)
            }
        }
        return fileSize
    }
    
    
    /// 获取当前时间
    ///
    /// - Parameter format: format
    /// - Returns: 时间
    public static func timeStampFormat(_ format: String) -> String {
        
        let nowDate = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let currentTime = dateFormatter.string(from: nowDate)
        
        return currentTime
    }
    
    /// 判断路径是否存在
    ///
    /// - Parameter path: 路径
    /// - Returns: true or false
    public static func fileExistAtPath(_ path: String) -> Bool {
        
        let fileManager = FileManager.default
        let isExist = fileManager.fileExists(atPath: path, isDirectory: nil)
        
        return isExist
    }
    
    /// 判断文件夹是否存在
    ///
    /// - Parameter atPath: 目录路径
    /// - Returns: true or false
    public static func isDirectory(atPath: String) -> Bool {
        var isDirectory: ObjCBool = ObjCBool(false)
        let fromExist = FileManager.default.fileExists(atPath: atPath,
                                                       isDirectory: &isDirectory)
        return fromExist && isDirectory.boolValue
    }
    
    /// 移出文件
    ///
    /// - Parameter path: 文件路径
    /// - Returns: true or false
    public static func removeFileAtPath(_ path: String) -> Bool {
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    /// 获取指定路径下所有文件
    ///
    /// - Parameter path: 文件路径
    /// - Returns: 文件数组
    public static func getAllTypeFiles(_ path: String) -> [String] {
        
        var paths = [String]()
        do {
            if fileExistAtPath(path) == false {
                let _ = createDirectory(atPath: path)
            }
            paths = try FileManager.default.contentsOfDirectory(atPath: path)
            
        } catch {
            return paths
        }
        return paths
    }
}
