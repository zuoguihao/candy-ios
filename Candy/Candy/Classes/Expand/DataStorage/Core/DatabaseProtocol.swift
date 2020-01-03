//
//  DatabaseProtocol.swift
//  DataStorage
//
//  Created by 左聂荣 on 2019/12/10.
//  Copyright © 2019 左聂荣. All rights reserved.
//

import Foundation
import WCDBSwift

public protocol DatabaseProtocol {
    var tableName: String { get }
}

public extension DatabaseProtocol where Self: TableCodable {
    var tableName: String {
        print("\(Self.self)")
        return "\(Self.self)"
    }

    /// 创建数据库对象
    /// - Parameter dbName: 数据库名
    static func creatDatabase(dbName: String? = nil) {
        DatabaseManager.creatDatabase(dbName: dbName)
    }

    /// 创建数据库中该类对应的表，类名即表名，无需指定
    static func createTable() {
        return DatabaseManager.create(table: "\(Self.self)", of: self)
    }

    /// 删除该类对应的表
    ///
    /// - Returns: 是否成功
    @discardableResult
    static func dropTable() -> Bool {
        return DatabaseManager.drop(table: "\(Self.self)")
    }

    /// 插入操作
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: 部分插入? 例如 Sample.Properties.identifier
    /// - Returns: 是否成功
    @discardableResult
    func insert(on propertyConvertibleList: [PropertyConvertible]? = nil) -> Bool {
        return DatabaseManager.shared.insert(objects: [self], on: propertyConvertibleList, intoTable: tableName)
    }

    /// 插入操作(如果已经存在那么替换)
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: 部分插入? 例如 Sample.Properties.identifier
    /// - Returns: 是否成功
    @discardableResult
    func insertOrReplace(on propertyConvertibleList: [PropertyConvertible]? = nil) -> Bool {
        return DatabaseManager.shared.insertOrReplace(objects: [self],
                                                      on: propertyConvertibleList,
                                                      intoTable: tableName)
    }

    /// 删除操作 如只设置表名 表示需要删除整个表的数据
    ///
    /// - Parameters:
    ///   - condition: 符合删除的条件
    ///   - orderList: 排序的方式
    ///   - limit: 删除的个数
    ///   - offset: 从第几个开始删除
    /// - Returns: 是否成功
    @discardableResult
    static func delete(where condition: Condition? = nil,
                       orderBy orderList: [OrderBy]? = nil,
                       limit: Limit? = nil,
                       offset: Offset? = nil) -> Bool {
        return DatabaseManager.shared.delete(
            fromTable: "\(Self.self)",
            where: condition,
            orderBy: orderList,
            limit: limit,
            offset: offset)
    }

    /// 更新操作
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: 要修改的字段
    ///   - object: 根据这个object得内容修改
    ///   - condition: 符合修改的条件
    ///   - orderList: 排序方式
    ///   - limit: 删除的个数
    ///   - offset: 从第几个开始删除
    @discardableResult
    func update(
        on propertyConvertibleList: [PropertyConvertible] = [],
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> Bool {
        return DatabaseManager.shared.update(table: tableName,
                                             on: propertyConvertibleList,
                                             with: self,
                                             where: condition,
                                             orderBy: orderList,
                                             limit: limit,
                                             offset: offset)
    }

    /// 获取操作
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: 部分获取某些字段 如不传 取全部
    ///   - condition: 符合查询的条件
    ///   - orderList: 排序方式
    ///   - limit: 删除的个数
    ///   - offset: 从符合条件的列表第几个开始删除
    /// - Returns: 结果
    static func getObjects(
        on propertyConvertibleList: [PropertyConvertible] = [],
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> [Self]? {
        return DatabaseManager.shared.getObjects(
            table: "\(Self.self)",
            on: propertyConvertibleList,
            where: condition,
            orderBy: orderList,
            limit: limit,
            offset: offset)
    }

    /// 获取单个对象
    ///
    /// - Parameters:
    ///   - propertyConvertibleList: 部分获取某些字段 如不传 取全部
    ///   - condition: 符合查询的条件
    /// - Returns: 结果
    static func getObject(
        on propertyConvertibleList: [PropertyConvertible] = [],
        where condition: Condition) -> Self? {
        return DatabaseManager.shared.getObjects(
            table: "\(Self.self)",
            on: propertyConvertibleList,
            where: condition,
            orderBy: nil,
            limit: 1,
            offset: nil)?.first
        }

    /// 值查询
    ///
    /// - Parameters:
    ///   - propertyConvertible: 要获取的值对应的属性
    ///   - condition: 符合查询的条件
    ///   - orderList: 排序方式
    ///   - limit: 查询的个数
    ///   - offset: 查询的列表的第几个开始获取
    /// - Returns: 结果
    static func getValue(
        on propertyConvertible: ColumnResultConvertible,
        where condition: Condition? = nil,
        orderBy orderList: [OrderBy]? = nil,
        limit: Limit? = nil,
        offset: Offset? = nil) -> FundamentalValue? {
        return DatabaseManager.shared.getValue(
            on: propertyConvertible,
            fromTable: "\(Self.self)",
            where: condition,
            orderBy: orderList,
            limit: limit,
            offset: offset)
    }

    /// 开启一个事务
    ///
    /// - Parameter transaction: 事务执行模块
    static func run(transaction: () -> Void) {
        DatabaseManager.run(table: "\(Self.self)", transaction: transaction)
    }

    /// 设置密码 (如果要给数据库设置密码 那么此方法要在增删查改之前执行, 否则会因为无法解密出错)
    ///
    /// - Parameter password: 密码
    static func setCipher(password: String) {
        let data = password.data(using: .ascii)
        DatabaseManager.setCipher(table: "\(Self.self)", key: data)
    }
}

// MARK: - 为数组添加扩展让其存在直接操作数据库的方法
public extension Array where Element: DatabaseProtocol & TableCodable {

    /// 插入数据
    ///
    /// - Parameter propertyConvertibleList: 要插入的字段 不传默认全部插入
    @discardableResult
    func insert(on propertyConvertibleList: [PropertyConvertible]? = nil) -> Bool {
        return DatabaseManager.shared.insert(objects: self, on: propertyConvertibleList, intoTable: "\(Element.self)")
    }

    /// 插入数据(如果已经存在那么替换)
    ///
    /// - Parameter propertyConvertibleList: 要插入的字段 不传默认全部插入
    @discardableResult
    func insertOrReplace(on propertyConvertibleList: [PropertyConvertible]? = nil) -> Bool {
        return DatabaseManager.shared.insertOrReplace(objects: self, on: propertyConvertibleList, intoTable: "\(Element.self)")
    }

}
