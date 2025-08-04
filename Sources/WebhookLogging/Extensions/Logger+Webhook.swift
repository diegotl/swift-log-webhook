import Foundation
import Logging

public extension Logger {
    func trace(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line,
        webhook: any Webhook
    ) {
        // Evaluate autoclosures before Task
        let evaluatedMessage = message()
        let evaluatedMetadata = metadata() ?? [:]
        let evaluatedSource = source() ?? ""

        // Send to webhook independently
        Task.detached {
            await WebhookSender.send(
                level: .trace,
                message: evaluatedMessage,
                metadata: evaluatedMetadata,
                source: evaluatedSource,
                file: file,
                function: function,
                line: line,
                configuration: webhook
            )
        }

        // Continue with normal logging
        self.trace(
            evaluatedMessage,
            metadata: evaluatedMetadata.isEmpty ? nil : evaluatedMetadata,
            source: evaluatedSource.isEmpty ? nil : evaluatedSource,
            file: file,
            function: function,
            line: line
        )
    }

    func debug(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line,
        webhook: any Webhook
    ) {
        // Evaluate autoclosures before Task
        let evaluatedMessage = message()
        let evaluatedMetadata = metadata() ?? [:]
        let evaluatedSource = source() ?? ""

        // Send to webhook independently
        Task.detached {
            await WebhookSender.send(
                level: .debug,
                message: evaluatedMessage,
                metadata: evaluatedMetadata,
                source: evaluatedSource,
                file: file,
                function: function,
                line: line,
                configuration: webhook
            )
        }

        // Continue with normal logging
        self.debug(
            evaluatedMessage,
            metadata: evaluatedMetadata.isEmpty ? nil : evaluatedMetadata,
            source: evaluatedSource.isEmpty ? nil : evaluatedSource,
            file: file,
            function: function,
            line: line
        )
    }

    func info(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line,
        webhook: any Webhook
    ) {
        // Evaluate autoclosures before Task
        let evaluatedMessage = message()
        let evaluatedMetadata = metadata() ?? [:]
        let evaluatedSource = source() ?? ""

        // Send to webhook independently
        Task.detached {
            await WebhookSender.send(
                level: .info,
                message: evaluatedMessage,
                metadata: evaluatedMetadata,
                source: evaluatedSource,
                file: file,
                function: function,
                line: line,
                configuration: webhook
            )
        }

        // Continue with normal logging
        self.info(
            evaluatedMessage,
            metadata: evaluatedMetadata.isEmpty ? nil : evaluatedMetadata,
            source: evaluatedSource.isEmpty ? nil : evaluatedSource,
            file: file,
            function: function,
            line: line
        )
    }

    func notice(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line,
        webhook: any Webhook
    ) {
        // Evaluate autoclosures before Task
        let evaluatedMessage = message()
        let evaluatedMetadata = metadata() ?? [:]
        let evaluatedSource = source() ?? ""

        // Send to webhook independently
        Task.detached {
            await WebhookSender.send(
                level: .notice,
                message: evaluatedMessage,
                metadata: evaluatedMetadata,
                source: evaluatedSource,
                file: file,
                function: function,
                line: line,
                configuration: webhook
            )
        }

        // Continue with normal logging
        self.notice(
            evaluatedMessage,
            metadata: evaluatedMetadata.isEmpty ? nil : evaluatedMetadata,
            source: evaluatedSource.isEmpty ? nil : evaluatedSource,
            file: file,
            function: function,
            line: line
        )
    }

    func warning(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line,
        webhook: any Webhook
    ) {
        // Evaluate autoclosures before Task
        let evaluatedMessage = message()
        let evaluatedMetadata = metadata() ?? [:]
        let evaluatedSource = source() ?? ""

        // Send to webhook independently
        Task.detached {
            await WebhookSender.send(
                level: .warning,
                message: evaluatedMessage,
                metadata: evaluatedMetadata,
                source: evaluatedSource,
                file: file,
                function: function,
                line: line,
                configuration: webhook
            )
        }

        // Continue with normal logging
        self.warning(
            evaluatedMessage,
            metadata: evaluatedMetadata.isEmpty ? nil : evaluatedMetadata,
            source: evaluatedSource.isEmpty ? nil : evaluatedSource,
            file: file,
            function: function,
            line: line
        )
    }

    func error(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line,
        webhook: any Webhook
    ) {
        // Evaluate autoclosures before Task
        let evaluatedMessage = message()
        let evaluatedMetadata = metadata() ?? [:]
        let evaluatedSource = source() ?? ""

        // Send to webhook independently
        Task.detached {
            await WebhookSender.send(
                level: .error,
                message: evaluatedMessage,
                metadata: evaluatedMetadata,
                source: evaluatedSource,
                file: file,
                function: function,
                line: line,
                configuration: webhook
            )
        }

        // Continue with normal logging
        self.error(
            evaluatedMessage,
            metadata: evaluatedMetadata.isEmpty ? nil : evaluatedMetadata,
            source: evaluatedSource.isEmpty ? nil : evaluatedSource,
            file: file,
            function: function,
            line: line
        )
    }

    func critical(
        _ message: @autoclosure () -> Logger.Message,
        metadata: @autoclosure () -> Logger.Metadata? = nil,
        source: @autoclosure () -> String? = nil,
        file: String = #fileID,
        function: String = #function,
        line: UInt = #line,
        webhook: any Webhook
    ) {
        // Evaluate autoclosures before Task
        let evaluatedMessage = message()
        let evaluatedMetadata = metadata() ?? [:]
        let evaluatedSource = source() ?? ""

        // Send to webhook independently
        Task.detached {
            await WebhookSender.send(
                level: .critical,
                message: evaluatedMessage,
                metadata: evaluatedMetadata,
                source: evaluatedSource,
                file: file,
                function: function,
                line: line,
                configuration: webhook
            )
        }

        // Continue with normal logging
        self.critical(
            evaluatedMessage,
            metadata: evaluatedMetadata.isEmpty ? nil : evaluatedMetadata,
            source: evaluatedSource.isEmpty ? nil : evaluatedSource,
            file: file,
            function: function,
            line: line
        )
    }
}
