import SwiftUI

public enum APIError: LocalizedError {
    case server(APIErrorResponse, logMessage: String? = nil)
    case jsonDecoding(logMessage: String? = nil)
    case requestTimedOut
    case mapping
    case unknown(logMessage: String? = nil)

    var message: String.LocalizationValue {
        switch self {
        case let .server(error, _):
            let serverError = error.mapToServerError()

            return """
            \(serverError.code ?? 9999): \(serverError.type ?? "Unknown")
            \(serverError.message)
            """
        case .jsonDecoding:
            return "JsonDecodingFailed"
        case .requestTimedOut:
            return "RequestTimedOut"
        case .mapping:
            return "MappingFailed"
        case .unknown:
            return "Unknown"
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
