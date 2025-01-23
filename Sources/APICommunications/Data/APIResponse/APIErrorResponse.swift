import Foundation

protocol APIErrorResponse {
    func mapToServerError() -> ServerError
}
