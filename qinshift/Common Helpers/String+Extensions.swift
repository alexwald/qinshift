import Foundation
import CryptoKit
import UIKit

extension String {
    func sha1() -> String {
        let data = Data(self.utf8)
        let hash = Insecure.SHA1.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func base64ToImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data)
        }
        return nil
    }
}
