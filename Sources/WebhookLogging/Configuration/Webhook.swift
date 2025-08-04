import Foundation
import Logging

public protocol Webhook: Sendable {
    var url: String { get }
    var headers: [String: String] { get }
    var timeout: TimeInterval { get }

    func createPayload(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) -> [String: Any]
}
