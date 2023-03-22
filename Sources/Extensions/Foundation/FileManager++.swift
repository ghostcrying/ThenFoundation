//
//  FileManager++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

// MARK: - FilePathCovertible

public protocol FilePathCovertible {
    
    func asFileURL() -> URL
    
    func asFilePath() -> String
}

extension String: FilePathCovertible {
    
    public func asFileURL() -> URL { URL(fileURLWithPath: self) }
    
    public func asFilePath() -> String { self }
}

extension URL: FilePathCovertible {
    
    public func asFileURL() -> URL { self }
    
    public func asFilePath() -> String { self.path }
}

public extension FilePathCovertible {
    
    /// 如果是文件夹，则返回true
    var isDirectoryPath: Bool { self.asFileURL().hasDirectoryPath }
    
    /// 文件或目录是否存在
    var isExists: Bool { FileManager.default.fileExists(atPath: self.asFilePath()) }
    
    /// 文件是否存在
    var isFileExists: Bool { FileManager.default.then.fileExists(at: self) }
    
    /// 目录是否存在
    var isDirectoryExists: Bool { FileManager.default.then.directoryExists(at: self) }
    
    /// 所有文件（渐遍历）
    var allFilePaths: [FilePathCovertible] {
        return (try? FileManager.default.then.allFilePaths(at: self)) ?? []
    }
    
    /// 所有文件（深遍历）
    var allSubFilePaths: [FilePathCovertible] {
        return (try? FileManager.default.then.allFilePaths(at: self, searchSub: true)) ?? []
    }
    
    /// 路径上的所有组件
    var filePathComponents: [String] { self.asFileURL().pathComponents }
    
    /// 路径最后的组件
    var lastFilePathComponent: String { self.asFileURL().lastPathComponent }

    /// 路径的后缀
    var filePathExtension: String { self.asFileURL().pathExtension }
    
    /// 文件名/文件夹名（去后缀）
    var filePathName: String { self.asFileURL().deletingFilePathExtension().lastFilePathComponent }
    
    /// 当前文件夹
    var directoryPath: FilePathCovertible { self.deletingLastFilePathComponent() }

    /// 添加路径元件，isDirectory: 是否为文件夹
    func appendingFilePathComponent(_ pathComponent: String, isDirectory: Bool) -> FilePathCovertible {
        self.asFileURL().appendingPathComponent(pathComponent, isDirectory: isDirectory)
    }

    /// 添加路径元件
    func appendingFilePathComponent(_ pathComponent: String) -> FilePathCovertible {
        self.asFileURL().appendingPathComponent(pathComponent)
    }

    /// 删除路径的最后一个元件
    func deletingLastFilePathComponent() -> FilePathCovertible {
        self.asFileURL().deletingLastPathComponent()
    }

    /// 添加后缀
    func appendingFilePathExtension(_ pathExtension: String) -> FilePathCovertible {
        self.asFileURL().appendingPathExtension(pathExtension)
    }
    
    /// 替换后缀名
    func replaceFilePathExtension(_ pathExtension: String) -> FilePathCovertible {
        self.deletingFilePathExtension().appendingFilePathExtension(pathExtension)
    }

    /// 删除后缀
    func deletingFilePathExtension() -> FilePathCovertible {
        self.asFileURL().deletingPathExtension()
    }
    
    func move(to filePath: FilePathCovertible) throws {
        try FileManager.default.then.moveItem(from: self, to: filePath)
    }
    
    func copy(to filePath: FilePathCovertible) throws {
        try FileManager.default.then.copyItem(from: self, to: filePath)
    }
    
    /// 将当前路径从文件夹中删除
    func removeFromDirectory() throws {
        try FileManager.default.then.removeItem(at: self)
    }
    
    /// 根据当前路径创建文件夹
    func createDirectory() throws {
        try FileManager.default.then.createDirectory(at: self)
    }
    
    @discardableResult
    func createFile() throws -> Bool {
        return try FileManager.default.then.createFile(at: self)
    }
}

// MARK: File Attributes

public extension FilePathCovertible {
    
    var attributes: [FileAttributeKey : Any]? { FileManager.default.then.attributesOfItem(at: self) }
    
    /// 修改时间
    var modificationDate: Date? { FileManager.default.then.modificationDateOfItem(at: self) }
    
    /// 创建时间
    var creationDate: Date? { FileManager.default.then.creationDateOfItem(at: self) }
    
    /// 文件/目录占用的磁盘空间大小
    var size: Int64 { FileManager.default.then.sizeOfItem(at: self) }
    
    /// 文件/目录占用的磁盘空间大小，如果是目录则统计目录中所有大小的总和
    var totalSize: Int64 { (try? FileManager.default.then.totalSizeOfItem(at: self)) ?? 0 }
}

/// MARK: - FileManager + PT

public extension ThenExtension where T == FileManager {
    
    var documentDirectoryPath: FilePathCovertible {
        if let path = urls(for: .documentDirectory, in: .userDomainMask).first {
            return path
        } else {
            return NSHomeDirectory().appendingFilePathComponent("Documents")
        }
    }
    
    var libraryDirectoryPath: FilePathCovertible {
        if let path = urls(for: .libraryDirectory, in: .userDomainMask).first {
            return path
        } else {
            return NSHomeDirectory().appendingFilePathComponent("Library")
        }
    }
    
    var temporaryDirectoryPath: FilePathCovertible { NSTemporaryDirectory() }
    
    var systemDiskSize: Int64 {
        do {
            let attributes = try base.attributesOfFileSystem(forPath: libraryDirectoryPath.asFilePath())
            return (attributes[.systemSize] as? Int64) ?? 0
        } catch {
            return 0
        }
    }
    
    var systemFreeDiskSize: Int64 {
        do {
            let attributes = try base.attributesOfFileSystem(forPath: libraryDirectoryPath.asFilePath())
            return (attributes[.systemFreeSize] as? Int64) ?? 0
        } catch {
            return 0
        }
    }
    
    func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [FilePathCovertible] {
        return base.urls(for: directory, in: domainMask)
    }
    
    func attributesOfItem(at path: FilePathCovertible) -> [FileAttributeKey : Any]? {
        guard path.isExists else { return nil }
        do {
            return try base.attributesOfItem(atPath: path.asFilePath())
        } catch {
            return nil
        }
    }
    
    func itemExists(at filePath: FilePathCovertible) -> Bool {
        return base.fileExists(atPath: filePath.asFilePath())
    }
    
    func directoryExists(at filePath: FilePathCovertible) -> Bool {
        var isDirectory = ObjCBool(false)
        let isExists = base.fileExists(atPath: filePath.asFilePath(), isDirectory: &isDirectory)
        return isDirectory.boolValue && isExists
    }
    
    func fileExists(at filePath: FilePathCovertible) -> Bool {
        var isDirectory = ObjCBool(false)
        let isExists = base.fileExists(atPath: filePath.asFilePath(), isDirectory: &isDirectory)
        return !isDirectory.boolValue && isExists
    }

    /// 根据文件夹路径创建文件夹
    func createDirectory(at directory: FilePathCovertible) throws {
        if directoryExists(at: directory) { return }
        try base.createDirectory(at: directory.asFileURL(), withIntermediateDirectories: true)
    }
    
    @discardableResult
    func createFile(at filePath: FilePathCovertible) throws -> Bool {
        if fileExists(at: filePath) { return true }
        try filePath.directoryPath.createDirectory()
        return base.createFile(atPath: filePath.asFilePath(), contents: nil, attributes: nil)
    }
    
    
    /// 文件夹下的所有文件
    /// - Parameters:
    ///   - directory: 目标文件夹路径
    ///   - searchSub: 是否包裹子目录下的文件
    ///   - options: 过滤选项,默认过滤隐藏文件
    func allFilePaths(at directory: FilePathCovertible, searchSub: Bool = false, options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]) throws -> [FilePathCovertible]? {
        guard directoryExists(at: directory) else { return nil }
        if searchSub {
            let enumerator = base.enumerator(at: directory.asFileURL(), includingPropertiesForKeys: nil, options: options, errorHandler: nil)
            return enumerator?.allObjects as? [URL]
        } else {
            return try base.contentsOfDirectory(at: directory.asFileURL(), includingPropertiesForKeys: nil, options: options)
        }
    }
    
    func moveItem(from: FilePathCovertible, to: FilePathCovertible) throws {
        guard from.isExists else { return }
        try createDirectory(at: to.directoryPath)
        try base.moveItem(at: from.asFileURL(), to: to.asFileURL())
    }
    
    func copyItem(from: FilePathCovertible, to: FilePathCovertible) throws {
        guard from.isExists else { return }
        try createDirectory(at: to.directoryPath)
        try base.copyItem(at: from.asFileURL(), to: to.asFileURL())
    }

    /// 根据路径删除文件/文件夹
    func removeItem(at filePath: FilePathCovertible) throws {
        guard filePath.isExists else { return }
        try base.removeItem(at: filePath.asFileURL())
    }
    
    func attributeOfItem(at path: FilePathCovertible, key: FileAttributeKey) -> Any? {
        return attributesOfItem(at: path)?[key]
    }
    
    func modificationDateOfItem(at path: FilePathCovertible) -> Date? {
        return attributeOfItem(at: path, key: .modificationDate) as? Date
    }
    
    func creationDateOfItem(at path: FilePathCovertible) -> Date? {
        return attributeOfItem(at: path, key: .creationDate) as? Date
    }
    
    func sizeOfItem(at path: FilePathCovertible) -> Int64 {
        return (attributeOfItem(at: path, key: .size) as? Int64) ?? 0
    }
    
    func totalSizeOfItem(at path: FilePathCovertible) throws -> Int64 {
        guard path.isDirectoryExists else { return sizeOfItem(at: path) }
        let subpaths = try FileManager.default.then.allFilePaths(at: path, searchSub: true, options: [])
        return subpaths?.reduce(0) { $0 + sizeOfItem(at: $1) } ?? 0
    }
    
}
