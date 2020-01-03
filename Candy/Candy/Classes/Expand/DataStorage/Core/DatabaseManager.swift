//
//  DatabaseManager.swift
//  DataStorage
//
//  Created by 左聂荣 on 2019/12/10.
//  Copyright © 2019 左聂荣. All rights reserved.
//

import Foundation
import WCDBSwift

//使用参考： https://github.com/Tencent/wcdb/wiki/Swift-增删查改

class DatabaseManager {

    ///单例
    static let shared = DatabaseManager()

    private init() {
        #if DEBUG
        debugPrint("DBFiles Path：\(dbPath)")
        #endif
    }

    private let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String ?? ""
    private lazy var dbPath = NSHomeDirectory() + "/Documents/" + "JLDBFiles" + "/"
    private lazy var database: Database = Database(withPath: dbPath + namespace + ".db")

    /// 创建数据库对象
    ///
    /// - Parameter dbName: 数据库名
    /// - Returns: 数据库
    static func creatDatabase(dbName: String? = nil) {
        if let dbName = dbName, !dbName.isEmpty, dbName != shared.namespace {
            shared.database = Database(withPath: shared.dbPath + dbName + ".db")
        }
    }

    /// 创建数据库表
    ///
    /// - Parameters:
    ///   - name: 表名
    ///   - rootType: 类
    static func create<Root: TableDecodable>(table name: String, of rootType: Root.Type) {
        do {
            try shared.database.create(table: name, of: rootType)
        } catch {
            debugPrint("create table error:", error)
        }
    }

}

extension DatabaseManager {

    /// 插入操作
    ///
    /// - Parameters:
    ///   - object: 要插入的对象
    ///   - propertyConvertibleList: 部分插入? 例如 Sample.Properties.identifier
    ///   - table: 表名
    /// - Returns: 是否成功
    @discardableResult
    func insert<Object: TableEncodable>(
        objects: [Object],
        on propertyConvertibleList: [PropertyConvertible]? = nil,
        intoTable table: String) -> Bool {
        do {
            try database.insert(objects: objects, on: propertyConvertibleList, intoTable: table)
            return true
        } catch let error {
            debugPrint("insert error:", error)
            return false
        }
    }

    /// 插入操作(如果已经存在那么替换)
    ///
    /// - Parameters:
    ///   - object: 要插入的对象
    ///   - propertyConvertibleList: 部分插入? 例如 Sample.Properties.identifier
    ///   - databaseName: 用来获取或创建 database
    /// - Returns: 是否成功
    @discardableResult
    func insertOrReplace<Object: TableEncodable>(
        objects: [Object],
        on propertyConvertibleList: [PropertyConvertible]? = nil,
        intoTable table: String) -> Bool {
        do {
            try database.insertOrReplace(objects: objects, on: propertyConvertibleList, intoTable: table)
            return true
        } catch let error {
            debugPrint("insertOrReplace error:", error)
            return false
        }
    }

    /// 删除操作 如只设置表名 表示需要删除整个表的数据,当时不会删除表本身
    ///
    /// - Parameters:
    ///   - table: 表名
    ///   - condition: 符合删除的条件
    ///   - orderList: 排序的方式
    ///   - limit: 删除的个数
    ///   - offset: 从第几个开始删除
    ///   - Returns: 是否删除成功
    @discardableResult
    func delete(
        fromTable table: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> Bool {
        do {
            try database.delete(fromTable: table, where: condition, orderBy: orderList, limit: limit, offset: offset)
            return true
        } catch let error {
            debugPrint("delete error:", error)
            return false
        }
    }

    /// 更新操作
    ///
    /// - Parameters:
    ///   - table: 表名
    ///   - propertyConvertibleList: 要修改的字段
    ///   - object: 根据这个object得内容修改
    ///   - condition: 符合修改的条件
    ///   - orderList: 排序方式
    ///   - limit: 删除的个数
    ///   - offset: 从第几个开始删除
    /// - Returns: 是否更新成功
    @discardableResult
    func update<Object: TableCodable>(
        table: String,
        on propertyConvertibleList: [PropertyConvertible],
        with object: Object,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> Bool {
        do {
            try database.update(table: table, on: propertyConvertibleList, with: object, where: condition, orderBy: orderList, limit: limit, offset: offset)
            return true
        } catch let error {
            debugPrint("update error:", error)
            return false
        }
    }

    /// 获取数据
    /// - Parameters:
    ///   - table: 表名
    ///   - propertyConvertibleList: 构成部分获取的方式 要获取的字段
    ///   - condition: 符合获取的条件
    ///   - orderList: 排序方式
    ///   - limit: 获取的个数
    ///   - offset: 从第几个开始获取
    func getObjects<Object: TableDecodable>(
        table: String,
        on propertyConvertibleList: [PropertyConvertible] = [],
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> [Object]? {
        let object: [Object]? = try? database.getObjects(
            on: propertyConvertibleList.isEmpty ? Object.Properties.all : propertyConvertibleList,
            fromTable: table,
            where: condition,
            orderBy: orderList,
            limit: limit,
            offset: offset)
        return object
    }

    /// 获取value
    /// - Parameters:
    ///   - columnResultConvertible: 获取哪个字段?
    ///   - table: 表名
    ///   - condition: 符合获取的条件
    ///   - orderList: 排序方式
    ///   - limit: 获取的个数
    ///   - offset: 从第几个开始获取
    func getValue(
        on columnResultConvertible: ColumnResultConvertible,
        fromTable table: String,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> FundamentalValue? {
        let value = try? database.getValue(on: columnResultConvertible, fromTable: table, where: condition, orderBy: orderList, limit: limit, offset: offset)
        return value
    }

    /// 删除表
    ///
    /// - Parameters:
    ///   - table: 要删除的表名
    /// - Returns: 是否成功
    @discardableResult
    static func drop(table: String) -> Bool {
        do {
            try shared.database.drop(table: table)
            return true
        } catch let error {
            debugPrint("drop error:", error)
            return false
        }
    }

    /// 删除数据库
    @discardableResult
    static func removeDBFile(table: String) -> Bool {
        do {
            try shared.database.close {
                try shared.database.removeFiles()
            }
            return true
        } catch {
            debugPrint("removeFiles error:", error)
            return false
        }
    }

    /// 开启事务
    ///
    /// - Parameters:
    ///   - transaction: 事务执行模块
    static func run(table: String, transaction: () -> Void) {
        try? shared.database.run(transaction: transaction)
    }

    /// 数据库设置密码
    ///
    /// - Parameters:
    ///   - optionalKey: 密码
    ///   - pageSize: 空间大小
    static func setCipher(table: String, key optionalKey: Data?, pageSize: Int = 4096) {
        shared.database.setCipher(key: optionalKey, pageSize: pageSize)
    }
}
