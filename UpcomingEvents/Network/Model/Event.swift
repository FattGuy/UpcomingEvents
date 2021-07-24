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
    var hasConflicts: Bool?
    var nextConflictedEventTitle: String?
    
    var startFullDate: Date {
        guard let date = start.toDate(.monthDayYearTime) else { return Date() }
        return date
    }
    
    var endFullDate: Date {
        guard let date = end.toDate(.monthDayYearTime) else { return Date() }
        return date
    }
    
    var startDate: Date {
        guard let date = start.toDate(.monthDayYearTime)?.removeTimeStamp else { return Date() }
        return date
    }
    
    var endDate: Date {
        guard let date = end.toDate(.monthDayYearTime)?.removeTimeStamp else { return Date() }
        return date
    }
}

struct EventDict: Codable {
    var title: String
    var events: [Event]
    
    init(title: String, events: [Event]) {
        self.title = title
        self.events = events
    }
}
