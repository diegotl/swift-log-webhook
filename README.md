# WebhookLogging

A Swift-Log API extension that adds webhook logging capabilities to any regular swift-log Logger instance. Currently comes with Slack and Mattermost webhook integration.

## Features

- **Works with any swift-log Logger**: No need to replace your existing Logger instances
- **User-defined namespaces**: Create your own webhook namespaces
- **Dual logging**: Messages go to both regular swift-log handlers AND webhooks when webhook parameter is provided
- Built-in Slack and Mattermost webhook support with rich formatting
- Configurable webhook endpoints with custom timeouts
- All standard log levels supported (trace, debug, info, notice, warning, error, critical)
- Extensibility for custom webhook providers

## Installation

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/diegotl/swift-log-webhook.git", from: "1.0.0")
]
```

## Usage

### Basic Setup

Define your custom webhook namespace and use regular swift-log Logger instances:

```swift
import Logging
import WebhookLogging

// Define your own webhook namespace
enum MyWebhooks {
    static let appLogs = SlackWebhook(url: "https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK")
    static let criticalLogs = MattermostWebhook(url: "https://example.com/hooks/YOURWEBHOOK")
}

// Create regular swift-log Logger
let logger = Logger(label: "com.yourapp.logger")
```

### Logging with Webhook Parameter

All log methods accept an additional `webhook` parameter using your defined webhooks:

```swift
// Basic logging with your custom namespace
logger.info("Application started", webhook: MyWebhooks.appLogs)
logger.warning("Low memory warning", webhook: MyWebhooks.criticalLogs)
logger.error("Failed to connect to database", webhook: MyWebhooks.criticalLogs)

// With metadata
logger.error(
    "User authentication failed", 
    metadata: ["userId": "12345", "ip": "192.168.1.1"], 
    webhook: MyWebhooks.slack
)
```

### Creating Custom Providers

To add support for other webhook services, implement the `Webhook` protocol:

```swift
public struct DiscordWebhook: Webhook {
    ...
}

// Add your custom providers to your namespace
enum MyWebhooks {
    static let discord = DiscordWebhookConfiguration(url: "https://discord.com/api/webhooks/...")
}
```

## License

MIT License
