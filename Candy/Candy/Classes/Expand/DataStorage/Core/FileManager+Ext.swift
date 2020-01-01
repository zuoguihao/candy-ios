//
//  FileManager+Ext
//  DataStorage
//
//  Created by 左聂荣 on 2019/12/10.
//  Copyright © 2019 左聂荣. All rights reserved.
//

import Foundation
import UIKit

public extension FileManager {
    
    /// database路径
    private var databasePath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    /// 命名空间
    private var namespace: String {
        return Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
    }
        
    /// 合并文件路径
    private var filePath: String {
        return databasePath + "/" + namespace + "/" + "fileManager" + "/"
    }
    
}

public extension FileManager {
    
    /// 写入文件(失败: 文件已存在或者不支持的文件类型)
    ///
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - file: 要写入的文件 Data/String/Dictionary/Array/UIImage
    /// - Returns: 是否成功
    @discardableResult
    func write(with fileName: String, file: Any) -> Bool {
        guard let suffixName = createAFileNameSuffixBasedOnTheFileType(with: file) else { return false }

        let fileAllPath = filePath + fileName
        
        if !fileExists(atPath: fileAllPath) {
            
            createFile(atPath: fileAllPath, contents: nil, attributes: nil)
            
            if suffixName == ".jpg" {
                
                try? (file as! UIImage).pngData()?.write(to: URL(fileURLWithPath: fileAllPath))
                return true
            } else {
                let isSuccess = (file as AnyObject).write(to: URL(fileURLWithPath: fileAllPath), atomically: true)
                print(isSuccess == true ? "写入成功":"写入失败")
                return isSuccess
            }
            
        }
        
        print("文件已存在")
        return false
        
    }
    
    /// 读取文件
    ///
    /// - Parameter fileName: 文件名称.
    func read(with fileName: String) -> Data? {
        let fileAllPath = filePath + fileName
        if fileExists(atPath: fileAllPath) {
            return contents(atPath: fileAllPath)
        }
        return nil
    }
    
    /// 读取数组文件
    /// 字典/数组 存储是以plist文件的格式存储的, 所以需要独立出来取值.
    /// - Parameter fileName: 文件名称.
    /// - Returns: 存在则返回结果 否则返回nil
    func readArray(with fileName: String) -> [AnyObject]? {
        let fileAllPath = filePath + fileName
        if fileExists(atPath: fileAllPath) {
            return NSArray(contentsOf: URL(fileURLWithPath: fileAllPath)) as [AnyObject]?
        }
        return nil
    }
    
    /// 读取字典文件
    /// 字典/数组 存储是以plist文件的格式存储的, 所以需要独立出来取值.
    /// - Parameter fileName: 文件名称.
    /// - Returns: 存在则返回结果 否则返回nil
    func readDictionary(with fileName: String) -> [String: AnyObject]? {
        let fileAllPath = filePath + fileName
        
        if fileExists(atPath: fileAllPath) {
            return NSDictionary(contentsOf: URL(fileURLWithPath: fileAllPath)) as? [String: AnyObject]
        }
        return nil
    }
    
    /// 删除文件(如test.jpg/test.plist/test.txt 如无后缀可不传)
    ///
    /// - Parameter fileName: 文件名称.
    /// - Returns: 是否成功
    @discardableResult
    func remove(with fileName: String) -> Bool {
        let fileAllPath = filePath + fileName
        if fileExists(atPath: fileAllPath) {
            try? removeItem(atPath: fileAllPath)
            //这里不catch错误, 直接返回成功.
            return true
        }
        return false
    }
    
    /// 获取文件大小(kb)
    ///
    /// - Parameter fileName: 文件全名称
    /// - Returns: 文件大小 如果文件不存在 则返回0 单位kb
    func getFileSize(with fileName: String) -> Double {
        let fileAllPath = filePath + fileName
        //判断文件是否存在
        if !fileExists(atPath: fileAllPath) {
            return 0
        }
        //获取FileAttributes
        guard let attribute = try? attributesOfItem(atPath: fileAllPath) else {
            return 0
        }
        
        let fileSize = attribute[.size] as? Double
        return (fileSize ?? 0) / 1024
        
    }
    
    /// 根据要存储的文件类型创建对应的后缀 规则: 数组/字典 后缀为plist, String 后缀为txt, UIImage后缀为jpg, Data为不可知具体类型后缀为"", 其它则返回nil
    ///
    /// - Parameter file: 文件
    /// - Returns: 后缀名称
    private func createAFileNameSuffixBasedOnTheFileType(with file: Any) -> String? {
        
        if file is Dictionary<String, Any> || file is Array<AnyObject> {
            return ".plist"
        } else if file is String {
            return ".txt"
        } else if file is UIImage {
            return ".jpg"
        } else if file is Data {
            return ""
        }
  
        return nil
    }
}
