import SystemConfiguration
import Foundation

public class AWSDKReachability {
    public enum Connection {
        case unavailable, cellular, wifi
    }

    public let session: URLSession
    public let host: String

    public required init(host: String, session: URLSession) {
        self.host = host
        self.session = session
    }

    private static var flags: SCNetworkReachabilityFlags? {
        // Create zero address
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)

        // Get flags for reachability
        var flags = SCNetworkReachabilityFlags()
        guard let routeReachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else { return nil }
        guard SCNetworkReachabilityGetFlags(routeReachability, &flags) else { return nil }
        return flags
    }

    public static func isConnectedToNetwork() -> Bool {
        return reachable
    }

    public static var reachable: Bool {
        guard let flags = self.flags else { return false }

        // Check if reachable and does not need connection
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let isConnected = (isReachable && !needsConnection)

        return isConnected
    }

    public static var connectionType: Connection {
        guard let flags = self.flags else { return .unavailable }

        // Check connection type
        let isOnWWAN = flags.contains(.isWWAN)
        let connection: Connection = isOnWWAN ? .cellular : .wifi

        return reachable ? connection : .unavailable
    }
}
