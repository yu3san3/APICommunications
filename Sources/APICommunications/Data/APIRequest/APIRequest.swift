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
    /// Set `Content-Type` and `Accept key` to `application/json`
    public static var defaultJsonHeaders: [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    public static func getHeaders(with headers: [String: String]) -> [String: String] {
        var tmp = defaultJsonHeaders
        tmp.merge(headers) { _, new in new }
        return tmp
    }

    public static func getHeadersWithAuthorizationHeader(
        value: String,
        with headers: [String: String] = [:]
    ) -> [String: String] {
        var tmp = defaultJsonHeaders
        tmp["Authorization"] = value
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
