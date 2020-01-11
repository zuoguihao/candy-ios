//
//  String+Ext.swift
//  Candy
//
//  Created by 左聂荣 on 2020/1/2.
//  Copyright © 2020 左聂荣. All rights reserved.
//

import Foundation

enum PredicateType: String {
    /// 手机号
    case phoneNumber = "^1(?:3\\d|4[4-9]|5[0-35-9]|6[67]|7[013-8]|8\\d|9\\d)\\d{8}$"
    /// 真我收发号
    case trueMe = "^[Tt][Zz][0-9]{6,}"//"[a-zA-Z0-9]{5,18}"
}

extension String {

    func substring(from: Int, to: Int) -> String {
        let fromIndex = index(startIndex, offsetBy: from)
        let toIndex = index(startIndex, offsetBy: to)
        return String(self[fromIndex..<toIndex])
    }

    /**
     String使用下标截取字符串
     例: "示例字符串"[0..<2] 结果是 "示例"
     */
    subscript (r: Range<Int>) -> String {
        let startIndex = index(self.startIndex, offsetBy: r.lowerBound, limitedBy: self.endIndex) ?? self.endIndex
        let endIndex = index(self.startIndex, offsetBy: r.upperBound, limitedBy: self.endIndex) ?? self.endIndex

        return String(self[startIndex..<endIndex])
    }

    //返回第一次出现的指定子字符串在此字符串中的索引
    func positionOf(sub: String) -> Int {
        var pos = -1
        if let range = range(of:sub) {
            if !range.isEmpty {
                pos = distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }

    /// 将当前字符串拼接到cache目录后面
    var cacheDir: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        return filePath
    }

    /// 将当亲字符串拼接到doc目录后面
    var docDir: String {
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        // 2.生成缓存路径
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)

        return filePath
    }

    /// 将当前字符串拼接到tmp目录后面
    var tmpDir: String {
        let path = NSTemporaryDirectory() as NSString
        return path.appendingPathComponent((self as NSString).lastPathComponent)
    }

    /// URL解码
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }

    /// encodeURIComponent编码方式,会对特殊符号编码【针对中文字符URL编码】
    func urlEncoded() -> String {
        let encodeUrlString = addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }

    /// encodeURI编码,不会对特殊符号编码【针对中文字符URL编码】
    func urlEncodedExceptSpecialCharacter() -> String {
        let character = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]")
        return addingPercentEncoding(withAllowedCharacters: character) ?? ""
    }

    /// 计算宽度
    func widthCalculation(height: CGFloat, font: UIFont) -> CGFloat {
        return sizeCalculation(size: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), font: font).width
    }

    /// 计算高度
    func heightCalculation(width: CGFloat, font: UIFont) -> CGFloat {
        return sizeCalculation(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), font: font).height
    }

    /// 计算 size
    func sizeCalculation(size: CGSize, font: UIFont) -> CGSize {
        guard count > 0 else { return CGSize.zero }

        return self.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }


    // 输入框实时正则校验：数字，小数点前面6位，小数点后允许两位
    ///
    /// - Parameters:
    ///   - newString: 传入的字符串 - 注意在 textfield 的shouldChangeCharactersIn代理方法中使用时，传入的字符串应为：(textField.text! as NSString).replacingCharacters(in: range, with: string)
    ///   - beforeDecimal: 小数点前的位数
    ///   - afterDecimal: 小数点后的位数
    /// - Returns: 是否允许输入
    func limitWithDecimal(before beforeDecimal: Int, after afterDecimal: Int, isNegative: Bool = false) -> Bool {
        /**
         对于模糊匹配
         如果关心的内容，就是用 (.*?)，然后通过索引可以获取结果
         如果不关心的内容，就是 .*? ，可以匹配任意的内容
         */
        let pattern = "^\(isNegative ? "-?" : "")\\d{0,\(beforeDecimal)}(\\.\\d{0,\(afterDecimal)})?$" //"^\\d{0,6}(\\.\\d{0,2})?$"

        // 创建正则表达式，如果pattern失败，抛出异常
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return false
        }

        // 进行查找，两种查找方法 - [只找第一个匹配项 / 查找多个匹配项]
        /**
         result中只有两个重要的方法
         result.numberOfRanges -> 查找到的范围
         result.rangeAt(idx) -> 指定'索引'位置的范围
         */
        let numberOfMatches = regx.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: count))
        return numberOfMatches != 0
    }

    /// 输入框实时正则校验：手机号正则校验
    func limitWithPhone() -> Bool {
        let pattern = "^1\\d{0,10}?$"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return false
        }
        let numberOfMatches = regx.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: count))
        return numberOfMatches != 0
    }

    /// 输入框实时正则校验：身份证
    func limitWithIDCard() -> Bool {
        let pattern = "^[1-9]\\d{0,16}([xX0-9])?$"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return false
        }
        let numberOfMatches = regx.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: count))
        return numberOfMatches != 0
    }

    /// 检测字符串是否符合规则
    func isValid(_ type: PredicateType) -> Bool {
        let pattern = type.rawValue

        let regex = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regex.evaluate(with: self)
    }

    func toObject<T>(_ : T.Type) -> T? where T: Codable {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
