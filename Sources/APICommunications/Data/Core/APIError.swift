import SwiftUI

enum APIError: LocalizedError {
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

protocol ServerError: Decodable, Sendable {
    var type: String? { get }
    var message: String { get }
    var code: Int? { get }
}
