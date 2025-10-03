import Foundation

let yearDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}()
