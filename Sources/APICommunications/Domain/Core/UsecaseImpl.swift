import Foundation

protocol Initializable {
    init()
}

struct UsecaseImpl<C: Initializable, M: Initializable> {
    let client: C
    let mapper: M

    init() {
        client = .init()
        mapper = .init()
    }
}
