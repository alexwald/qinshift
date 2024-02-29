import Foundation

class DefaultsStorage {
    var store: UserDefaults

    // MARK: - Inits
    convenience init() {
        self.init(userDefaults: .standard)
    }

    init(userDefaults: UserDefaults) {
        self.store = userDefaults
    }

    // MARK: - Removals
    func removeAllValues() {
        if let domain = Bundle.main.bundleIdentifier {
            store.removePersistentDomain(forName: domain)
            store.synchronize()
        }
    }

    // MARK: - Subscripts
    subscript(key: StorageKeys) -> String? {
        get { return self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }

    subscript(key: String) -> String? {
        get { return store.string(forKey: key) }
        set {
            store.set(newValue, forKey: key)
            store.synchronize()
        }
    }

    subscript(bool key: StorageKeys) -> Bool {
        get { return self[bool: key.rawValue] }
        set { self[bool: key.rawValue] = newValue }
    }

    subscript(bool key: String) -> Bool {
        get { return store.bool(forKey: key) }
        set {
            store.set(newValue, forKey: key)
            store.synchronize()
        }
    }

    subscript(integer key: StorageKeys) -> Int? {
        get { return self[integer: key.rawValue] }
        set { self[integer: key.rawValue] = newValue }
    }

    subscript(integer key: String) -> Int? {
        get { return store.object(forKey: key) as? Int }
        set {
            store.set(newValue, forKey: key)
            store.synchronize()
        }
    }

    subscript(double key: StorageKeys) -> Double? {
        get { return self[double: key.rawValue] }
        set { self[double: key.rawValue] = newValue }
    }

    subscript(double key: String) -> Double? {
        get { return store.object(forKey: key) as? Double }
        set {
            store.set(newValue, forKey: key)
            store.synchronize()
        }
    }

    subscript(data key: StorageKeys) -> Data? {
        get { return self[data: key.rawValue] }
        set { self[data: key.rawValue] = newValue }
    }

    subscript(data key: String) -> Data? {
        get { return store.data(forKey: key) }
        set {
            store.set(newValue, forKey: key)
            store.synchronize()
        }
    }

    subscript(date key: StorageKeys) -> Date? {
        get { return self[date: key.rawValue] }
        set { self[date: key.rawValue] = newValue }
    }

    subscript(date key: String) -> Date? {
        get { return store.value(forKey: key) as? Date }
        set {
            store.set(newValue, forKey: key)
            store.synchronize()
        }
    }
}
