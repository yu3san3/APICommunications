import Foundation

extension URLQueryItem: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(value, forKey: .value)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case value
    }
}
