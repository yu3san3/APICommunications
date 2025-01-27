import PrettyFormatter
import Foundation

// Extension for `allHttpHeaders` property.
extension Dictionary where Key == AnyHashable, Value == Any {
    var prettyFormatted: String {
        PrettyFormatter().prettyFormatted(self)
    }
}
