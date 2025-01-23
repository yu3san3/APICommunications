import SwiftUI

public enum APIError: LocalizedError {
    case server(ServerError, logMessage: String? = nil)
    case jsonDecoding(logMessage: String? = nil)
    case requestTimedOut
    case mapping
    case unknown(logMessage: String? = nil)

    var message: String.LocalizationValue {
        switch self {
        case let .server(error, _):
            """
            \(error.code ?? 9999): \(error.type ?? "Unknown")
            \(error.message)
            """
        case .jsonDecoding:
            "JsonDecodingFailed"
        case .requestTimedOut:
            "RequestTimedOut"
        case .mapping:
            "MappingFailed"
        case .unknown:
            "Unknown"
        }
    }

    var logMessage: String {
        switch self {
        case let .server(_, message):
            message.descriptionOrNil
        case let .jsonDecoding(message):
            message.descriptionOrNil
        case .requestTimedOut:
            "Request Timed Out"
        case .mapping:
            "Mapping Error"
        case let .unknown(message):
            message.descriptionOrNil
        }
    }
}

public struct ServerError: Decodable, Sendable {
    public let type: String?
    public let message: String
    public let code: Int?

    public init(
        type: String?,
        message: String,
        code: Int?
    ) {
        self.type = type
        self.message = message
        self.code = code
    }
}
