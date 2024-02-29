import Foundation

 class StorageController {
    var defaultsStorage: DefaultsStorage
    var fileController: FileController


    // MARK: - Get/Set String defaults values
     subscript(key: StorageKeys) -> String? {
        get { return defaultsStorage[key] }
        set { defaultsStorage[key] = newValue }
    }

    // To access default properties we can use StorageKey directly or any other String as a key
     subscript(key: String) -> String? {
        get { return defaultsStorage[key] }
        set { defaultsStorage[key] = newValue }
    }

    // MARK: - Get/Set Bool defaults values
     subscript(bool key: StorageKeys) -> Bool {
        get { return defaultsStorage[bool: key] }
        set { defaultsStorage[bool: key] = newValue }
    }

     subscript(bool key: String) -> Bool {
        get { return defaultsStorage[bool: key] }
        set { defaultsStorage[bool: key] = newValue }
    }

    // MARK: - Get/Set Int defaults values
     subscript(integer key: StorageKeys) -> Int? {
        get { return defaultsStorage[integer: key] }
        set { defaultsStorage[integer: key] = newValue }
    }

     subscript(integer key: String) -> Int? {
        get { return defaultsStorage[integer: key] }
        set { defaultsStorage[integer: key] = newValue }
    }

    // MARK: - Get/Set Double defaults values
     subscript(double key: StorageKeys) -> Double? {
        get { return defaultsStorage[double: key] }
        set { defaultsStorage[double: key] = newValue }
    }

     subscript(double key: String) -> Double? {
        get { return defaultsStorage[double: key] }
        set { defaultsStorage[double: key] = newValue }
    }

    // MARK: - Get/Set Data defaults values
     subscript(data key: StorageKeys) -> Data? {
        get { return defaultsStorage[data: key] }
        set { defaultsStorage[data: key] = newValue }
    }

     subscript(data key: String) -> Data? {
        get { return defaultsStorage[data: key] }
        set { defaultsStorage[data: key] = newValue }
    }

    // MARK: - Get/Set Date defaults values
     subscript(date key: StorageKeys) -> Date? {
        get { return defaultsStorage[date: key] }
        set { defaultsStorage[date: key] = newValue }
    }

     subscript(date key: String) -> Date? {
        get { return defaultsStorage[date: key] }
        set { defaultsStorage[date: key] = newValue }
    }

    // MARK: - Init functions
     convenience init() {
        self.init(
            defaults: .standard,
            fileManager: .default
        )
    }

     init(
        defaults: UserDefaults,
        fileManager: FileManager
    ) {
        self.defaultsStorage = DefaultsStorage(userDefaults: defaults)
        self.fileController = FileController(fileManager: fileManager)
    }

    // MARK: - Removing all keys
     func removeAll() {
        defaultsStorage.removeAllValues()
    }
}

// MARK: - Work with FileManager - calling FileController's functions
extension StorageController {
     var documentsDirectoryURL: URL {
        return fileController.documentsDirectoryURL
    }

     func fileURL(withName name: String) -> URL {
        return fileController.fileURL(withName: name)
    }

     func fileExists(withName name: String) -> Bool {
        return fileController.fileExists(withName: name)
    }

     func fileExists(at fileURL: URL) -> Bool {
        return fileController.fileExists(at: fileURL)
    }

     func deleteFile(withName name: String) throws {
        try fileController.deleteFile(withName: name)
    }

     func removeItem(at fileURL: URL) throws {
        try fileController.removeItem(at: fileURL)
    }

     func removeAllFiles() throws {
        try fileController.removeAllFiles()
    }

     func getFileURLsBy(fileExtension: String) -> [URL] {
        return fileController.getFileURLsBy(fileExtension: fileExtension)
    }

     func createDirectory(withName name: String) throws {
        try fileController.createDirectory(withName: name)
    }

     func contentsOfDirectory(withName name: String) throws -> [URL] {
        return try fileController.contentsOfDirectory(withName: name)
    }

     func moveItem(at sourceURL: URL, to destinationURL: URL) throws {
        try fileController.moveItem(at: sourceURL, to: destinationURL)
    }

     func attributesOfItem(atPath path: String) throws -> NSDictionary {
        return try fileController.attributesOfItem(atPath: path)
    }

     func setAttributes(_ attributes: [FileAttributeKey: Any], ofItemAtPath path: String) throws {
        try fileController.setAttributes(attributes, ofItemAtPath: path)
    }
}
