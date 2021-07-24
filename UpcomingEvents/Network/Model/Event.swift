//
//  Event.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import Foundation

struct Event: Codable {
    var title: String
    var start: String
    var end: String
    
    var startDate: Date {
        guard let date = start.toDate(.monthDayYearTime) else { return Date() }
        return date
    }
    
    var endDate: Date {
        guard let date = end.toDate(.monthDayYearTime) else { return Date() }
        return date
    }
}
