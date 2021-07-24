//
//  DateFormatterExtensions.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import Foundation

extension DateFormatter {
    
    static let shared = DateFormatter()
    
    enum CustomDateFormat: String {
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" // 2016-05-03T11:15:54.950+05:00
        case atom = "yyyy-MM-dd'T'HH:mm:ssZZZ" // 2017-05-13T18:56:43+0000
        case rfc3339 = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" // 2017-12-12T00:00:00+05:00
        case timeOnly = "hh:mm a" // 6:31 PM
        case lastUpdated = "M/d h:mm a" // Updated d/MM h:mm a
        case shortStringHyphen = "yyyy-MM-dd" // 2016-08-31
        case shortDateSlash = "MM/dd/yyyy" // 04/30/2016
        case extraShortDateSlash = "MM/dd/yy" // 04/30/16
        case shortDateDot = "MM.dd.yyyy" // 04.30.2016
        case extraShortDateDot = "MM.dd.yy" // 04.30.16
        case timeDateSlash = "hh:mm a MM/dd/yyyy" // 6:30 PM 3/20/2016
        case monthYear = "MMM yyyy" //Aug 2017
        case fullMonthYear = "MMMM yyyy" //August 2017
        case fullMonthDay = "MMMM d" //August 3
        case fullMonthDayCommaYear = "MMMM d, yyyy"
        case dayOfTheWeek = "EEEE"
        case monthDayYearTime = "MMMM dd, yyyy hh:mm a"
    }
    
    fileprivate class func string(from date: Date?, with format: CustomDateFormat) -> String? {
        guard let date = date else { return nil }
        DateFormatter.shared.dateFormat = format.rawValue
        return DateFormatter.shared.string(from: date)
    }
    
    fileprivate class func date(from string: String?, with format: CustomDateFormat) -> Date? {
        guard let string = string else { return nil }
        DateFormatter.shared.dateFormat = format.rawValue
        return DateFormatter.shared.date(from: string)
    }
    
}

extension String {
    
    func toDate(_ format: DateFormatter.CustomDateFormat) -> Date? {
        return DateFormatter.date(from: self, with: format)
    }
    
}
