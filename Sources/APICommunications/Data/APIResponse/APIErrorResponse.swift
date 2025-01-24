import Foundation

public protocol APIErrorResponse: Sendable {
    func mapToServerError() -> ServerError
}
