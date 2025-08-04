@testable import WebhookLogging
import Foundation
import Logging
import Testing

@Test func validURLStringCreatesSlackWebhook() async throws {
    let validURL = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
    let webhook = SlackWebhook(url: validURL)

    #expect(webhook.url == validURL)
    #expect(webhook.timeout == 30.0)
    #expect(webhook.headers["Content-Type"] == "application/json")
}

@Test func validURLStringCreatesMattermostWebhook() async throws {
    let validURL = "https://mattermost.example.com/hooks/xxx-generatedkey-xxx"
    let webhook = MattermostWebhook(url: validURL, username: "TestBot")

    #expect(webhook.url == validURL)
    #expect(webhook.username == "TestBot")
    #expect(webhook.timeout == 30.0)
    #expect(webhook.headers["Content-Type"] == "application/json")
}

@Test func slackWebhookCreatesCorrectPayload() async throws {
    let webhook = SlackWebhook(url: "https://example.com/webhook")
    let metadata: Logger.Metadata = ["key": "value"]

    let payload = webhook.createPayload(
        level: .error,
        message: "Test message",
        metadata: metadata,
        source: "TestSource",
        file: "/path/to/file.swift",
        function: "testFunction",
        line: 42
    )

    #expect(payload["attachments"] != nil)

    if let attachments = payload["attachments"] as? [[String: Any]],
       let attachment = attachments.first {
        #expect(attachment["color"] as? String == "#f44336")
        #expect(attachment["title"] as? String == "❌ ERROR Log")
        #expect(attachment["text"] as? String == "Test message")
        #expect(attachment["footer"] as? String == "WebhookLogging")

        if let fields = attachment["fields"] as? [[String: Any]] {
            #expect(fields.count == 5) // Level, Source, File, Function, Metadata
        }
    }
}

@Test func mattermostWebhookCreatesCorrectPayload() async throws {
    let webhook = MattermostWebhook(url: "https://example.com/webhook", username: "Logger")
    let metadata: Logger.Metadata = ["user": "test"]

    let payload = webhook.createPayload(
        level: .warning,
        message: "Warning message",
        metadata: metadata,
        source: "TestApp",
        file: "/src/main.swift",
        function: "main",
        line: 10
    )

    #expect(payload["text"] as? String == "⚠️ **WARNING**: Warning message")
    #expect(payload["username"] as? String == "Logger")

    if let attachments = payload["attachments"] as? [[String: Any]],
       let attachment = attachments.first {
        #expect(attachment["color"] as? String == "warning")
    }
}

@Test func webhookSenderHandlesInvalidURL() async throws {
    // Create a webhook with invalid URL
    let invalidWebhook = SlackWebhook(url: "not-a-valid-url")

    // This should not crash and should handle the error gracefully
    await WebhookSender.send(
        level: .info,
        message: "Test message",
        metadata: [:],
        source: "Test",
        file: #file,
        function: #function,
        line: #line,
        configuration: invalidWebhook
    )

    // If we reach here without crashing, the test passes
    #expect(true)
}

@Test func webhookSenderHandlesEmptyURL() async throws {
    let emptyWebhook = SlackWebhook(url: "")

    await WebhookSender.send(
        level: .debug,
        message: "Debug message",
        metadata: [:],
        source: "Test",
        file: #file,
        function: #function,
        line: #line,
        configuration: emptyWebhook
    )

    #expect(true)
}

@Test func slackWebhookEmojiMapping() async throws {
    let webhook = SlackWebhook(url: "https://example.com/webhook")

    let levels: [Logger.Level] = [.trace, .debug, .info, .notice, .warning, .error, .critical]
    let expectedEmojis = ["🔍", "🐛", "ℹ️", "📌", "⚠️", "❌", "🚨"]

    for (level, expectedEmoji) in zip(levels, expectedEmojis) {
        let payload = webhook.createPayload(
            level: level,
            message: "Test",
            metadata: [:],
            source: "Test",
            file: #file,
            function: #function,
            line: #line
        )

        if let attachments = payload["attachments"] as? [[String: Any]],
           let attachment = attachments.first,
           let title = attachment["title"] as? String {
            #expect(title.contains(expectedEmoji))
        }
    }
}

@Test func mattermostWebhookEmojiMapping() async throws {
    let webhook = MattermostWebhook(url: "https://example.com/webhook")

    let levels: [Logger.Level] = [.trace, .debug, .info, .notice, .warning, .error, .critical]
    let expectedEmojis = ["🔍", "🐛", "ℹ️", "📌", "⚠️", "❌", "🚨"]

    for (level, expectedEmoji) in zip(levels, expectedEmojis) {
        let payload = webhook.createPayload(
            level: level,
            message: "Test",
            metadata: [:],
            source: "Test",
            file: #file,
            function: #function,
            line: #line
        )

        if let text = payload["text"] as? String {
            #expect(text.contains(expectedEmoji))
        }
    }
}
