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
    var headers: [String: String] { get set }
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

    public mutating func appendHeaders(_ additionalHeaders: [String: String]) {
        additionalHeaders.forEach { key, value in
            headers[key] = value
        }
    }

    public mutating func appendAuthorizationHeader(value: String) {
        headers["Authorization"] = value
    }
}
