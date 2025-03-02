import Foundation

public protocol Initializable {
    init()
}

public struct UsecaseImpl<C: Initializable, M: Initializable> {
    public let client: C
    public let mapper: M

    public init() {
        client = .init()
        mapper = .init()
    }
}
