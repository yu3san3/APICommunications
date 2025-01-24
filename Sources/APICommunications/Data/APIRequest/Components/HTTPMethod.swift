import Foundation

public enum HTTPMethod: String {
    case get
    case post

    var methodName: String {
        rawValue.uppercased()
    }
}
