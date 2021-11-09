



import Foundation

public enum Week {
    
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var index: Int {
        switch self {
        case .sunday:
            return 0
        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        case .thursday:
            return 4
        case .friday:
            return 5
        case .saturday:
            return 6
        }
    }
}

public extension Date {
    
    /// User’s current calendar.
    var calendar: Calendar {
        return Calendar.current
    }

    /// Era.
    ///
    /// Date().era -> 1
    ///
    var era: Int {
        return Calendar.current.component(.era, from: self)
    }

    /// Quarter.
    ///
    /// Date().quarter -> 3 // date in third quarter of the year.
    ///
    var quarter: Int {
        let month = Double(Calendar.current.component(.month, from: self))
        let numberOfMonths = Double(Calendar.current.monthSymbols.count)
        let numberOfMonthsInQuarter = numberOfMonths / 4
        return Int(ceil(month/numberOfMonthsInQuarter))
    }

    /// Week of year.
    ///
    /// Date().weekOfYear -> 2 // second week in the year.
    ///
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }

    /// Week of month.
    ///
    ///  Date().weekOfMonth -> 3 // date is in third week of the month.
    ///
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    var year: Int {
        get {
            return Calendar.current.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = Calendar.current.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = Calendar.current.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
    var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = Calendar.current.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }
    
    var day: Int {
        get {
            return Calendar.current.component(.day, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = Calendar.current.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = Calendar.current.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
    
    var hour: Int {
        get {
            return Calendar.current.component(.hour, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentHour = Calendar.current.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = Calendar.current.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }
    
    var minute: Int {
        get {
            return Calendar.current.component(.minute, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = Calendar.current.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = Calendar.current.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    var second: Int {
        get {
            return Calendar.current.component(.second, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = Calendar.current.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = Calendar.current.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 纳秒
    var nanosecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self)
        }
        set {
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentNanoseconds = Calendar.current.component(.nanosecond, from: self)
            let nanosecondsToAdd = newValue - currentNanoseconds

            if let date = Calendar.current.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 毫秒
    var millisecond: Int {
        get {
            return Calendar.current.component(.nanosecond, from: self) / 1000000
        }
        set {
            let nanoSeconds = newValue * 1000000
            let allowedRange = Calendar.current.range(of: .nanosecond, in: .second, for: self)!
            guard allowedRange.contains(nanoSeconds) else { return }

            if let date = Calendar.current.date(bySetting: .nanosecond, value: nanoSeconds, of: self) {
                self = date
            }
        }
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /// 1: 星期日 7:星期六
    var weekdayIndex: Week {
        
        let index = Calendar.current.component(.weekday, from: self)
        switch index {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            fatalError()
        }
    }
}

public extension Date {
    
    static func date(year: Int, month: Int, day: Int) -> Date {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents)!
    }
    
    static func date(_ dateStr: String, formatter: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateStr)
    }
    
    /// 获取当前时间戳 精确到毫秒
    static func getMilliTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss SSS"
        let datetime = CLongLong(round(Date().timeIntervalSince1970 * 1000))
        return "\(datetime)"
    }
    
    /// 获取当前时间戳 精确到秒
    static func getSecTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let datetime = CLongLong(round(Date().timeIntervalSince1970))
        return "\(datetime)"
    }
    
    /// 如果13位时间戳，格式要加上毫秒
    static func timeIntervalToTime(_ timestamp: Double, _ formatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date:Date = Date.init(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date as Date)
    }
       
    /// 第几天
    func daysInMonth() -> Int {
        if let range = Calendar.current.range(of: .day, in: .month, for: self) {
            return range.count
        }
        return 0
    }

    /// Date string from date.
    ///
    ///     Date().dateString(ofStyle: .short) -> "1/12/17"
    ///     Date().dateString(ofStyle: .medium) -> "Jan 12, 2017"
    ///     Date().dateString(ofStyle: .long) -> "January 12, 2017"
    ///     Date().dateString(ofStyle: .full) -> "Thursday, January 12, 2017"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date string.
    func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// Date and time string from date.
    ///
    ///     Date().dateTimeString(ofStyle: .short) -> "1/12/17, 7:32 PM"
    ///     Date().dateTimeString(ofStyle: .medium) -> "Jan 12, 2017, 7:32:00 PM"
    ///     Date().dateTimeString(ofStyle: .long) -> "January 12, 2017 at 7:32:00 PM GMT+3"
    ///     Date().dateTimeString(ofStyle: .full) -> "Thursday, January 12, 2017 at 7:32:00 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date and time string.
    func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    /// Time string from date
    ///
    ///     Date().timeString(ofStyle: .short) -> "7:37 PM"
    ///     Date().timeString(ofStyle: .medium) -> "7:37:02 PM"
    ///     Date().timeString(ofStyle: .long) -> "7:37:02 PM GMT+3"
    ///     Date().timeString(ofStyle: .full) -> "7:37:02 PM GMT+03:00"
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: time string.
    func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }
}

extension Date {

    /// the same year
    ///
    /// - Parameter date: contrast time
    /// - Returns: true: equal; false: not equal
    func haveSameYear(_ date: Date) -> Bool {
        return self.year == date.year
    }

    func haveSameYearAndMonth(_ date: Date) -> Bool {
        return self.haveSameYear(date) && self.month == date.month
    }

    func haveSameYearMonthAndDay(_ date: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let components2 = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return components1 == components2
    }

    func haveSameYearMonthDayAndHour(_ date: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self)
        let components2 = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        return components1 == components2
    }

    func haveSameYearMonthDayHourAndMinute(_ date: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let components2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        return components1 == components2
    }

    func haveSameYearMonthDayHourMinuteAndSecond(_ date: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        let components2 = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        return components1 == components2
    }
}
