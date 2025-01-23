import Foundation

extension Optional where Wrapped: CustomStringConvertible {
    var descriptionOrNil: String {
        self?.description ?? "nil"
    }
}

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

// MARK: - PrettyPrintedString

extension Data {
    var prettyPrintedJsonString: String {
        guard let object = try? JSONSerialization.jsonObject(with: self),
              let data = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted]
              ),
              let string = String(data: data, encoding: .utf8)
        else {
            return "nil"
        }

        return string
    }
}

extension Dictionary where Key == AnyHashable, Value: Any {
    var prettyPrintedString: String {
        guard let data = try? JSONSerialization.data(
            withJSONObject: self,
            options: [.prettyPrinted]
        ) else {
            return "nil"
        }

        return data.prettyPrintedJsonString
    }
}

extension Encodable {
    var prettyPrintedJsonString: String {
        guard let data = try? JSONEncoder().encode(self) else {
            return "nil"
        }

        return data.prettyPrintedJsonString
    }
}
