import Foundation

public protocol APIErrorResponse: Decodable, Sendable {
    func mapToServerError() -> ServerError
}
