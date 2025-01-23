import Foundation

public protocol APIErrorResponse {
    func mapToServerError() -> ServerError
}
