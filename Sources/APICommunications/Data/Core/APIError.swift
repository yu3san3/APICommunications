import SwiftUI

public enum APIError: LocalizedError {
    case server(APIErrorResponse, logMessage: String? = nil)
    case jsonDecoding(logMessage: String? = nil)
    case requestTimedOut
    case mapping
    case unknown(logMessage: String? = nil)

    public var localizedTitle: String {
        .init(localized: title)
    }

    public var localizedMessage: String {
        .init(localized: message)
    }

    var logMessage: String {
        switch self {
        case let .server(_, logMessage):
            logMessage.descriptionOrNil
        case let .jsonDecoding(logMessage):
            logMessage.descriptionOrNil
        case .requestTimedOut:
            "Request Timed Out"
        case .mapping:
            "Mapping Error"
        case let .unknown(logMessage):
            logMessage.descriptionOrNil
        }
    }

    private var title: String.LocalizationValue {
        switch self {
        case .server:
            "ServerErrorTitle"
        case .jsonDecoding:
            "JsonDecodingFailedTitle"
        case .requestTimedOut:
            "RequestTimedOutTitle"
        case .mapping:
            "MappingFailedTitle"
        case .unknown:
            "UnknownTitle"
        }
    }

    private var message: String.LocalizationValue {
        switch self {
        case let .server(error, _):
            let serverError = error.mapToServerError()

            return """
            \(serverError.code ?? 9999): \(serverError.type ?? "Unknown")
            \(serverError.message)
            """
        case .jsonDecoding, .mapping:
            return "ContactDeveloperIfOccursRepeatedlyMessage"
        case .requestTimedOut, .unknown:
            return "TryAgainAfterWaitingMessage"
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
