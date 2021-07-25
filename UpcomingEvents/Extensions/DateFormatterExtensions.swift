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
        case monthDayYearTime = "MMMM dd, yyyy hh:mm a"
        case monthDayYear = "MMMM dd, yyyy"
        case shortMonthDayYearTime = "MMM dd, yyyy hh:mm a"
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

extension Date {
    
    public var removeTimeStamp : Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return nil
        }
        return date
    }
    
    func toString(_ format: DateFormatter.CustomDateFormat) -> String? {
        return DateFormatter.string(from: self, with: format)
    }
}
