import Foundation

public protocol APIHTTPBody: Encodable {}

public struct EmptyBody: APIHTTPBody {
    public init() {}
}
