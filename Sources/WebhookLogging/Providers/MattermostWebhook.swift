import Foundation
import Logging

public struct MattermostWebhook: Webhook {
    public let url: String
    public let headers: [String: String]
    public let timeout: TimeInterval
    public let username: String
    public let channel: String?
    public let iconUrl: String?

    public init(
        url: String,
        username: String = "WebhookLogging",
        channel: String? = nil,
        iconUrl: String? = nil,
        timeout: TimeInterval = 30.0
    ) {
        self.url = url
        self.headers = ["Content-Type": "application/json"]
        self.timeout = timeout
        self.username = username
        self.channel = channel
        self.iconUrl = iconUrl
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

        var payload: [String: Any] = [
            "text": "\(emoji) **\(level.rawValue.uppercased())**: \(message)",
            "username": username,
            "attachments": [
                [
                    "color": color,
                    "fields": fields,
                    "footer": "WebhookLogging",
                    "ts": Int(Date().timeIntervalSince1970)
                ]
            ]
        ]

        // Add optional channel override
        if let channel = channel {
            payload["channel"] = channel
        }

        // Add optional icon URL
        if let iconUrl = iconUrl {
            payload["icon_url"] = iconUrl
        }

        return payload
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
        case .trace, .debug:    "good"      // Green in Mattermost
        case .info, .notice:    "#2196F3"   // Blue
        case .warning:          "warning"   // Orange in Mattermost
        case .error:            "danger"    // Red in Mattermost
        case .critical:         "#9c27b0"   // Purple
        }
    }
}
