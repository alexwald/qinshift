import Foundation

public enum FileError: String, Error, CaseIterable {
    case fileDoesNotExist
    case noData
    case other

    public var codeIndex: Int {
        return Self.allCases.firstIndex(of: self) ?? 0
    }
}


public class FileController {
    let fileManager: FileManager

    public init(
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
    }
}

// MARK: - Serialize JSON files
extension FileController {
    public func loadData<T: Decodable>(from fileName: String, decoder: JSONDecoder) async throws -> T {
        guard self.fileExists(withName: fileName) else { throw FileError.fileDoesNotExist }

        let fileURL = self.fileURL(withName: fileName)
        let data = try Data(contentsOf: fileURL)
        let model = try decoder.decode(T.self, from: data)
        return model
    }

    public func storeData<T: Encodable>(
        _ model: T, to fileName: String,
        encoder: JSONEncoder, options: Data.WritingOptions = .completeFileProtection
    ) async throws {
        let fileURL = self.fileURL(withName: fileName)
        let data = try encoder.encode(model)
        try data.write(to: fileURL, options: options)
    }
}

// MARK: - Work with FileManager
extension FileController {
    public var documentsDirectoryURL: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    public func fileURL(withName name: String) -> URL {
        return documentsDirectoryURL.appendingPathComponent(name)
    }

    public func fileExists(withName name: String) -> Bool {
        let path = fileURL(withName: name).path
        return fileManager.fileExists(atPath: path)
    }

    public func fileExists(at fileURL: URL) -> Bool {
        return fileManager.fileExists(atPath: fileURL.path)
    }

    public func deleteFile(withName name: String) throws {
        guard fileExists(withName: name) else { return }
        try removeItem(at: fileURL(withName: name))
    }

    public func removeItem(at fileURL: URL) throws {
        try fileManager.removeItem(at: fileURL)
    }

    public func removeAllFiles() throws {
        let contents = try fileManager.contentsOfDirectory(atPath: documentsDirectoryURL.path)

        for path in contents {
            try deleteFile(withName: path)
        }
    }

    public func getFileURLsBy(fileExtension: String) -> [URL] {
        var result: [URL]?
        let fileURLs = try? fileManager.contentsOfDirectory(at: documentsDirectoryURL, includingPropertiesForKeys: nil)
        result = fileURLs?.filter { $0.lastPathComponent.hasSuffix(fileExtension) }
        return result ?? []
    }

    public func createDirectory(withName name: String) throws {
        try fileManager.createDirectory(
            atPath: fileURL(withName: name).path,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }

    public func contentsOfDirectory(withName name: String) throws -> [URL] {
        return try fileManager.contentsOfDirectory(
            at: documentsDirectoryURL.appendingPathComponent(name),
            includingPropertiesForKeys: nil
        )
    }

    public func moveItem(at sourceURL: URL, to destinationURL: URL) throws {
        try fileManager.moveItem(at: sourceURL, to: destinationURL)
    }

    public func attributesOfItem(atPath path: String) throws -> NSDictionary {
        try fileManager.attributesOfItem(atPath: path) as NSDictionary
    }

    public func setAttributes(_ attributes: [FileAttributeKey: Any], ofItemAtPath path: String) throws {
        try fileManager.setAttributes(attributes, ofItemAtPath: path)
    }
}
