import Foundation

public enum CodingStrategy {
    case convertSnakeCase
    case useDefaultKeys

    var encoding: JSONEncoder.KeyEncodingStrategy {
        switch self {
        case .convertSnakeCase: .convertToSnakeCase
        case .useDefaultKeys: .useDefaultKeys
        }
    }

    var decoding: JSONDecoder.KeyDecodingStrategy {
        switch self {
        case .convertSnakeCase: .convertFromSnakeCase
        case .useDefaultKeys: .useDefaultKeys
        }
    }
}
