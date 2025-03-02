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

    /// エラーメッセージをローカライズされた値として取得するプロパティ。
    ///
    /// 各エラーケースに応じた適切なメッセージを返す。
    /// - `.server` の場合: サーバーエラーのコード、タイプ、およびメッセージを含む文字列
    ///   - エラーの `code` が `nil` の場合は `9999` を返す。
    ///   - エラーの `type` が `nil` の場合は `"Unknown"` を返す。
    /// - `.jsonDecoding`, `.mapping` の場合: 繰り返し発生する場合に開発者へ連絡を促すメッセージ
    /// - `.requestTimedOut`, `.unknown` の場合: 一定時間待ってから再試行するよう促すメッセージ
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
