//
//  Date++.swift
//  ThenFoundation
//
//  Created by ghost on 2023/3/14.
//

import Foundation

extension Date: ThenExtensionCompatible { }

private let weekdays: Array = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]

public extension ThenExtension where T == Date {
    
    /// ThenFoundation: User’s current seconds.
    // var second: Second { return value.timeIntervalSince1970.second }
    
    /// ThenFoundation: User’s current calendar.
    var calendar: Calendar {
        // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
        return Calendar(identifier: Calendar.current.identifier)
    }

    /// ThenFoundation: Era.
    ///
    ///        Date().then.era -> 1
    ///
    var era: Int {
        return calendar.component(.era, from: value)
    }

    #if !os(Linux)
    /// ThenFoundation: Quarter.
    ///
    ///        Date().then.quarter -> 3 // date in third quarter of the year.
    ///
    var quarter: Int {
        let month = Double(calendar.component(.month, from: value))
        let numberOfMonths = Double(calendar.monthSymbols.count)
        let numberOfMonthsInQuarter = numberOfMonths / 4
        return Int(Darwin.ceil(month / numberOfMonthsInQuarter))
    }
    #endif

    /// ThenFoundation: Week of year.
    ///
    ///        Date().then.weekOfYear -> 2 // second week in the year.
    ///
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: value)
    }

    /// ThenFoundation: Week of month.
    ///
    ///        Date().then.weekOfMonth -> 3 // date is in third week of the month.
    ///
    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: value)
    }

    /// ThenFoundation: Year.
    ///
    ///        Date().then.year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return calendar.component(.year, from: value)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: value)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: value) {
                value = date
            }
        }
    }

    /// ThenFoundation: Month.
    ///
    ///     Date().then.month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    var month: Int {
        get {
            return calendar.component(.month, from: value)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: value)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: value)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: value) {
                value = date
            }
        }
    }

    /// ThenFoundation: Day.
    ///
    ///     Date().then.day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    var day: Int {
        get {
            return calendar.component(.day, from: value)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: value)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: value)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: value) {
                value = date
            }
        }
    }

    /// ThenFoundation: Weekday.
    ///
    ///     Date().then.weekday -> 5 // fifth day in the current week.
    ///
    var weekday: Int {
        return calendar.component(.weekday, from: value)
    }
    
    /// 星期的中文描述 -> ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    var weekdayChineseDescription: String? {
        return weekdays[safe: (weekday) - 1]
    }

    /// ThenFoundation: Hour.
    ///
    ///     Date().then.hour -> 17 // 5 pm
    ///
    ///     var someDate = Date()
    ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
    ///
    var hour: Int {
        get {
            return calendar.component(.hour, from: value)
        }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: value)!
            guard allowedRange.contains(newValue) else { return }

            let currentHour = calendar.component(.hour, from: value)
            let hoursToAdd = newValue - currentHour
            if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: value) {
                value = date
            }
        }
    }

    /// ThenFoundation: Minutes.
    ///
    ///     Date().then.minute -> 39
    ///
    ///     var someDate = Date()
    ///     someDate.minute = 10 // sets someDate's minutes to 10.
    ///
    var minute: Int {
        get {
            return calendar.component(.minute, from: value)
        }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: value)!
            guard allowedRange.contains(newValue) else { return }

            let currentMinutes = calendar.component(.minute, from: value)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: value) {
                value = date
            }
        }
    }

    /// ThenFoundation: Seconds.
    ///
    ///     Date().then.second -> 55
    ///
    ///     var someDate = Date()
    ///     someDate.second = 15 // sets someDate's seconds to 15.
    ///
    var second: Int {
        get {
            return calendar.component(.second, from: value)
        }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: value)!
            guard allowedRange.contains(newValue) else { return }

            let currentSeconds = calendar.component(.second, from: value)
            let secondsToAdd = newValue - currentSeconds
            if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: value) {
                value = date
            }
        }
    }

    /// ThenFoundation: Nanoseconds.
    ///
    ///     Date().then.nanosecond -> 981379985
    ///
    ///     var someDate = Date()
    ///     someDate.nanosecond = 981379985 // sets someDate's seconds to 981379985.
    ///
    var nanosecond: Int {
        get {
            return calendar.component(.nanosecond, from: value)
        }
        set {
            #if targetEnvironment(macCatalyst)
            // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
            let allowedRange = 0..<1_000_000_000
            #else
            let allowedRange = calendar.range(of: .nanosecond, in: .second, for: value)!
            #endif
            guard allowedRange.contains(newValue) else { return }

            let currentNanoseconds = calendar.component(.nanosecond, from: value)
            let nanosecondsToAdd = newValue - currentNanoseconds

            if let date = calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: value) {
                value = date
            }
        }
    }

    /// ThenFoundation: Milliseconds.
    ///
    ///     Date().then.millisecond -> 68
    ///
    ///     var someDate = Date()
    ///     someDate.millisecond = 68 // sets someDate's nanosecond to 68000000.
    ///
    var millisecond: Int {
        get {
            return calendar.component(.nanosecond, from: value) / 1_000_000
        }
        set {
            let nanoSeconds = newValue * 1_000_000
            #if targetEnvironment(macCatalyst)
            // The `Calendar` implementation in `macCatalyst` does not know that a nanosecond is 1/1,000,000,000th of a second
            let allowedRange = 0..<1_000_000_000
            #else
            let allowedRange = calendar.range(of: .nanosecond, in: .second, for: value)!
            #endif
            guard allowedRange.contains(nanoSeconds) else { return }

            if let date = calendar.date(bySetting: .nanosecond, value: nanoSeconds, of: value) {
                value = date
            }
        }
    }

    /// ThenFoundation: Check if date is in future.
    ///
    ///     Date(timeInterval: 100, since: Date()).isInFuture -> true
    ///
    var isInFuture: Bool {
        return value > Date()
    }

    /// ThenFoundation: Check if date is in past.
    ///
    ///     Date(timeInterval: -100, since: Date()).isInPast -> true
    ///
    var isInPast: Bool {
        return value < Date()
    }

    /// ThenFoundation: Check if date is within today.
    ///
    ///     Date().then.isInToday -> true
    ///
    var isInToday: Bool {
        return calendar.isDateInToday(value)
    }

    /// ThenFoundation: Check if date is within yesterday.
    ///
    ///     Date().then.isInYesterday -> false
    ///
    var isInYesterday: Bool {
        return calendar.isDateInYesterday(value)
    }

    /// ThenFoundation: Check if date is within tomorrow.
    ///
    ///     Date().then.isInTomorrow -> false
    ///
    var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(value)
    }

    /// ThenFoundation: Check if date is within a weekend period.
    var isInWeekend: Bool {
        return calendar.isDateInWeekend(value)
    }

    /// ThenFoundation: Check if date is within a weekday period.
    var isWorkday: Bool {
        return !calendar.isDateInWeekend(value)
    }

    /// ThenFoundation: Check if date is within the current week.
    var isInCurrentWeek: Bool {
        return calendar.isDate(value, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// ThenFoundation: Check if date is within the current month.
    var isInCurrentMonth: Bool {
        return calendar.isDate(value, equalTo: Date(), toGranularity: .month)
    }

    /// ThenFoundation: Check if date is within the current year.
    var isInCurrentYear: Bool {
        return calendar.isDate(value, equalTo: Date(), toGranularity: .year)
    }

    /// ThenFoundation: ISO8601 string of format (yyyy-MM-dd'T'HH:mm:ss.SSS) from date.
    ///
    ///     Date().then.iso8601String -> "2017-01-12T14:51:29.574Z"
    ///
    var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: value).appending("Z")
    }

    /// ThenFoundation: Nearest five minutes to date.
    ///
    ///     var date = Date() // "5:54 PM"
    ///     date.minute = 32 // "5:32 PM"
    ///     date.nearestFiveMinutes // "5:30 PM"
    ///
    ///     date.minute = 44 // "5:44 PM"
    ///     date.nearestFiveMinutes // "5:45 PM"
    ///
    var nearestFiveMinutes: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: value)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// ThenFoundation: Nearest ten minutes to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestTenMinutes // "5:30 PM"
    ///
    ///     date.minute = 48 // "5:48 PM"
    ///     date.nearestTenMinutes // "5:50 PM"
    ///
    var nearestTenMinutes: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: value)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// ThenFoundation: Nearest quarter hour to date.
    ///
    ///     var date = Date() // "5:57 PM"
    ///     date.minute = 34 // "5:34 PM"
    ///     date.nearestQuarterHour // "5:30 PM"
    ///
    ///     date.minute = 40 // "5:40 PM"
    ///     date.nearestQuarterHour // "5:45 PM"
    ///
    var nearestQuarterHour: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: value)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// ThenFoundation: Nearest half hour to date.
    ///
    ///     var date = Date() // "6:07 PM"
    ///     date.minute = 41 // "6:41 PM"
    ///     date.nearestHalfHour // "6:30 PM"
    ///
    ///     date.minute = 51 // "6:51 PM"
    ///     date.nearestHalfHour // "7:00 PM"
    ///
    var nearestHalfHour: Date {
        var components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second, .nanosecond],
            from: value)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    /// ThenFoundation: Nearest hour to date.
    ///
    ///     var date = Date() // "6:17 PM"
    ///     date.nearestHour // "6:00 PM"
    ///
    ///     date.minute = 36 // "6:36 PM"
    ///     date.nearestHour // "7:00 PM"
    ///
    var nearestHour: Date {
        let min = calendar.component(.minute, from: value)
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour]
        let date = calendar.date(from: calendar.dateComponents(components, from: value))!

        if min < 30 {
            return date
        }
        return calendar.date(byAdding: .hour, value: 1, to: date)!
    }

    /// ThenFoundation: Yesterday date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let yesterday = date.yesterday // "Oct 2, 2018, 10:57:11"
    ///
    var yesterday: Date {
        return calendar.date(byAdding: .day, value: -1, to: value) ?? Date()
    }

    /// ThenFoundation: Tomorrow's date.
    ///
    ///     let date = Date() // "Oct 3, 2018, 10:57:11"
    ///     let tomorrow = date.tomorrow // "Oct 4, 2018, 10:57:11"
    ///
    var tomorrow: Date {
        return calendar.date(byAdding: .day, value: 1, to: value) ?? Date()
    }

    /// ThenFoundation: UNIX timestamp from date.
    ///
    ///        Date().then.unixTimestamp -> 1484233862.826291
    ///
    var unixTimestamp: Double {
        return value.timeIntervalSince1970
    }
    
    /// ThenFoundation: Today's last date
    /// last seconds:  23:59:59
    var lastSecondDate: Date? {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: value)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)
    }
    
    /// ThenFoundation: Today's begin date
    /// begin seconds: 00:00:00
    var beginSecondDate: Date? {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: value)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)
    }
    
}
