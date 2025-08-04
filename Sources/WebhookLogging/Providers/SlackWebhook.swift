import Foundation
import Logging

public struct SlackWebhook: Webhook {
    public let url: String
    public let headers: [String: String]
    public let timeout: TimeInterval

    public init(url: String, timeout: TimeInterval = 30.0) {
        self.url = url
        self.headers = ["Content-Type": "application/json"]
        self.timeout = timeout
    }

    public func createPayload(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) -> [String: Any] {
        let emoji = levelEmoji(for: level)
        let color = levelColor(for: level)

        var fields: [[String: Any]] = [
            ["title": "Level", "value": level.rawValue.uppercased(), "short": true],
            ["title": "Source", "value": source, "short": true],
            ["title": "File", "value": "\(URL(fileURLWithPath: file).lastPathComponent):\(line)", "short": true],
            ["title": "Function", "value": function, "short": true]
        ]

        if !metadata.isEmpty {
            let metadataString = metadata.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
            fields.append(["title": "Metadata", "value": metadataString, "short": false])
        }

        return [
            "attachments": [
                [
                    "color": color,
                    "title": "\(emoji) \(level.rawValue.uppercased()) Log",
                    "text": "\(message)",
                    "fields": fields,
                    "footer": "WebhookLogging",
                    "ts": Int(Date().timeIntervalSince1970)
                ]
            ]
        ]
    }

    private func levelEmoji(for level: Logger.Level) -> String {
        switch level {
        case .trace:    "🔍"
        case .debug:    "🐛"
        case .info:     "ℹ️"
        case .notice:   "📌"
        case .warning:  "⚠️"
        case .error:    "❌"
        case .critical: "🚨"
        }
    }

    private func levelColor(for level: Logger.Level) -> String {
        switch level {
        case .trace, .debug:    "#36a64f"
        case .info, .notice:    "#2196F3"
        case .warning:          "#ff9800"
        case .error:            "#f44336"
        case .critical:         "#9c27b0"
        }
    }
}
