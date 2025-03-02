import Foundation

public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case patch

    var methodName: String {
        rawValue.uppercased()
    }
}
