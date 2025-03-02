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

    /// 指定されたヘッダーをデフォルトのJSONヘッダーと統合します。
    ///
    /// - Parameter headers: 追加するヘッダーの辞書。
    /// - Returns: デフォルトのJSONヘッダーに指定されたヘッダーを統合した辞書。
    public static func mergedHeaders(with headers: [String: String]) -> [String: String] {
        var tmp = defaultJsonHeaders
        tmp.merge(headers) { _, new in new }
        return tmp
    }

    /// 認証トークンを含むヘッダーを生成します。
    ///
    /// `Authorization` ヘッダーをデフォルトのJSONヘッダーに追加し、さらに指定された追加ヘッダーを統合します。
    ///
    /// - Parameters:
    ///   - token: `Authorization` ヘッダーに設定する認証トークン。
    ///   - headers: 追加するヘッダーの辞書（デフォルトは空の辞書）。
    /// - Returns: `Authorization` ヘッダーを含むデフォルトのJSONヘッダーと追加ヘッダーを統合した辞書。
    public static func mergedHeadersWithAuthorization(
        token: String,
        with headers: [String: String] = [:]
    ) -> [String: String] {
        var tmp = defaultJsonHeaders
        tmp["Authorization"] = token
        tmp.merge(headers) { _, new in new }
        return tmp
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
