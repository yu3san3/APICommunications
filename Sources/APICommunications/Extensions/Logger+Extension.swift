import OSLog

extension Logger {
    init(label: String) {
        self = .init(subsystem: "APICommunications", category: label)
    }
}
