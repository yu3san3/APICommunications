import Foundation

public protocol APIRequest {
    associatedtype Response: APIResponse
    associatedtype ErrorResponse: APIErrorResponse
    associatedtype HTTPBody: APIHTTPBody

    var codingStrategy: CodingStrategy { get }
    var httpMethod: HTTPMethod { get }
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var body: HTTPBody { get }
    var queryItems: [URLQueryItem] { get }
}

extension APIRequest {
    /// APIリクエストのデフォルトJSONヘッダー。
    ///
    /// `Content-Type` と `Accept` ヘッダーを `application/json` に設定します。
    public static var defaultJsonHeaders: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    /// デフォルトのJSONヘッダーと指定されたヘッダーを統合した新しい辞書を返します。
    ///
    /// `defaultHeaders` に `headers` を統合し、キーが重複した場合は `headers` の値を優先します。
    ///
    /// - Parameters:
    ///   - additionalHeaders: 追加するヘッダーの辞書。
    ///   - baseHeaders: 基本となるヘッダー（デフォルトは `defaultJsonHeaders`）。
    /// - Returns: `baseHeaders` に `additionalHeaders` を統合した新しい辞書。
    public static func headers(
        merging additionalHeaders: [String: String],
        baseHeaders: [String: String] = defaultJsonHeaders
    ) -> [String: String] {
        baseHeaders.merging(additionalHeaders, uniquingKeysWith: { _, new in new })
    }

    /// 認証トークンを含むヘッダーを生成します。
    ///
    /// `Authorization` ヘッダーを基本ヘッダーに追加し、さらに指定された追加ヘッダーを統合します。
    ///
    /// - Parameters:
    ///   - token: `Authorization` ヘッダーに設定する認証トークン。
    ///   - type: 認証方式 (`Bearer` や `Basic` など)。デフォルトは `Bearer`。
    ///   - additionalHeaders: 追加するヘッダーの辞書（デフォルトは空の辞書）。
    ///   - baseHeaders: 基本となるヘッダー（デフォルトは `defaultJsonHeaders`）。
    /// - Returns: `Authorization` ヘッダーを含む基本ヘッダーと追加ヘッダーを統合した辞書。
    public static func headersWithAuthorization(
        token: String,
        type: AuthorizationHeaderType = .bearer,
        merging additionalHeaders: [String: String] = [:],
        baseHeaders: [String: String] = defaultJsonHeaders
    ) -> [String: String] {
        let authorizationHeader = ["Authorization": "\(type.rawValue) \(token)"]

        return baseHeaders
            .merging(authorizationHeader, uniquingKeysWith: { _, new in new })
            .merging(additionalHeaders, uniquingKeysWith: { _, new in new })
    }

    var prettyPrintedRequest: String {
        return """
        method: \(httpMethod.methodName),
        baseUrl: \(scheme)://\(host),
        path: \(path),
        headers: \(headers.prettyFormatted),
        body: \(body.prettyFormatted),
        queryItems: \(queryItems.prettyFormatted)
        """
    }
}
