import PrettyFormatter
import Foundation

// `allHttpHeaders` のための Extension
extension Dictionary where Key == AnyHashable, Value == Any {
    var prettyFormatted: String {
        PrettyFormatter().prettyFormatted(self)
    }
}
