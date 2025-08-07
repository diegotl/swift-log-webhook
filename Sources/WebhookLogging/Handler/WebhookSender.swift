import Foundation
import Logging
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@MainActor
public enum WebhookSender {
    private static let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        return URLSession(configuration: config)
    }()

    public static func send(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata,
        source: String,
        file: String,
        function: String,
        line: UInt,
        configuration: any Webhook
    ) async {
        let payload = configuration.createPayload(
            level: level,
            message: message,
            metadata: metadata,
            source: source,
            file: file,
            function: function,
            line: line
        )

        await sendWebhook(
            payload: payload,
            configuration: configuration
        )
    }

    private static func sendWebhook(
        payload: [String: Any],
        configuration: any Webhook
    ) async {
        do {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
                return
            }

            guard let url = URL(string: configuration.url) else {
                print("WebhookLogging: Invalid URL string: \(configuration.url)")
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.timeoutInterval = configuration.timeout

            for (key, value) in configuration.headers {
                request.setValue(value, forHTTPHeaderField: key)
            }

            let (_, response) = try await urlSession.data(for: request)

            // Optional: Log response status for debugging
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode >= 400 {
                print("WebhookLogging: HTTP \(httpResponse.statusCode) error")
            }

        } catch {
            print("WebhookLogging failed to send: \(error)")
        }
    }
}
