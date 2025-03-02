import Foundation

public enum CodingStrategy {
    case convertToSnakeCase
    case useDefaultKeys

    var encoding: JSONEncoder.KeyEncodingStrategy {
        switch self {
        case .convertToSnakeCase: .convertToSnakeCase
        case .useDefaultKeys: .useDefaultKeys
        }
    }

    var decoding: JSONDecoder.KeyDecodingStrategy {
        switch self {
        case .convertToSnakeCase: .convertFromSnakeCase
        case .useDefaultKeys: .useDefaultKeys
        }
    }
}
