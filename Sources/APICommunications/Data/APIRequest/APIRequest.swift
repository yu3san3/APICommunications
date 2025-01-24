import Foundation

public protocol APIRequest {
    associatedtype Response: Decodable
    associatedtype ErrorResponse: Decodable & APIErrorResponse
    associatedtype HTTPBody: Encodable

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

    static func authorizationHeaders(accessToken: String) -> [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }

    var prettyPrintedRequest: String {
        return """
        method: \(httpMethod.rawValue.uppercased()),
        baseUrl: \(scheme)://\(host),
        path: \(path),
        headers: \(headers.prettyFormatted),
        body: \(body.prettyFormatted),
        queryItems: \(queryItems.prettyFormatted)
        """
    }
}
