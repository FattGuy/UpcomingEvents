//
//  UpcomingEventsPresenter.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

protocol UpcomingEventsView: AnyObject {
    func showEvents(_ eventDicts: [EventDict])
    func showError(_ errorMessage: String)
    func showConflictedEvent(_ titles: Set<String>)
}

protocol UpcomingEventPresentation {
    func getEvents()
    func handleConflictIconClick(_ event: Event)
}

class UpcomingEventPresenter: UpcomingEventPresentation {
    
    weak var view: UpcomingEventsView?
    var service: EventProvider.Type = EventService.self
    var events: [Event]
    
    init(with view: UpcomingEventsView) {
        self.view = view
        self.events = []
    }
    
    func start() {
        self.getEvents()
    }
    
    func getEvents() {
        service.getEvents { [weak self] (result) in
            switch result {
            case .success(let events):
                let sorted = self?.sortEvents(events ?? [])
                self?.groupEvents(sorted ?? [])
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    /// Return a sorted event list.
    ///
    /// Use this method to sorted event list using the event endFullDate and startFullDate.
    func sortEvents(_ events: [Event]) -> [Event] {
        
        var sortedWithEndDate = events.sorted(by: {
            $0.endFullDate.compare($1.endFullDate) == .orderedAscending
        })
        sortedWithEndDate = self.markConflicts(sortedEndDate: &sortedWithEndDate)
        
        var sortedWithStartDate = sortedWithEndDate.sorted(by: {
            $0.startFullDate.compare($1.startFullDate) == .orderedAscending
        })
        sortedWithStartDate = self.markConflicts(sortedStartDate: &sortedWithStartDate)
        
        return sortedWithStartDate
    }
    
    /// Group event list.
    ///
    /// Use this method to group event list by event startDate.
    func groupEvents(_ events: [Event]) {
        let eventsDict = Dictionary(grouping: events, by: { $0.startDate.toString(.monthDayYear) ?? "" })
        
        var eventDicts = [EventDict]()
        
        for dict in eventsDict.sorted(by: { $0.key.localizedCompare($1.key) == .orderedAscending }) {
            let eventDict = EventDict(title: dict.key, events: dict.value)
            eventDicts.append(eventDict)
        }
        
        self.view?.showEvents(eventDicts)
    }
    
    /// Mark the conflict events in the event list
    ///
    ///     Use event A's and B's startDate and endDate timeInterval,
    ///     if B.startDateTimeInterval <= A.startDateTimeInterval { A.hasConflict = true; B.hasConflict = true }
    ///     else if B.startDateTimeInterval > A.startDateTimeInterval && B.startDateTimeInterval < A.endDateTimeInterval { A.hasConflict = true; B.hasConflict = true }
    ///
    /// - Parameter sortedEndDate: The sorted event list using event endDate.
    ///
    /// - Complexity: O(n) since the event list is sorted in chronological order.
    func markConflicts(sortedEndDate: inout [Event]) -> [Event] {
        for i in 1..<sortedEndDate.count {
            let startIntervalA = sortedEndDate[i-1].startFullDate.timeIntervalSince1970
            let endIntervalA = sortedEndDate[i-1].endFullDate.timeIntervalSince1970
            let startIntervalB = sortedEndDate[i].startFullDate.timeIntervalSince1970
            
            if startIntervalB <= startIntervalA {
                self.updateEventConflictInfo(&sortedEndDate, i)
            } else if startIntervalB > startIntervalA && startIntervalB < endIntervalA {
                self.updateEventConflictInfo(&sortedEndDate, i)
            }
        }
        
        return sortedEndDate
    }
    
    /// Mark the conflict events in the event list
    ///
    ///     Use event A's and B's startDate and endDate timeInterval,
    ///     if B.endDateTimeInterval <= A.endDateTimeInterval { A.hasConflict = true; B.hasConflict = true }
    ///     else if B.endDateTimeInterval > A.endDateTimeInterval && B.startDateTimeInterval < A.endDateTimeInterval { A.hasConflict = true; B.hasConflict = true }
    ///
    /// - Parameter sortedStartDate: The sorted event list using event startDate.
    ///
    /// - Complexity: O(n) since the event list is sorted in chronological order.
    func markConflicts(sortedStartDate: inout [Event]) -> [Event] {
        for i in 1..<sortedStartDate.count {
            let endIntervalA = sortedStartDate[i-1].endFullDate.timeIntervalSince1970
            let startIntervalB = sortedStartDate[i].startFullDate.timeIntervalSince1970
            let endIntervalB = sortedStartDate[i].endFullDate.timeIntervalSince1970
            
            if endIntervalB <= endIntervalA {
                self.updateEventConflictInfo(&sortedStartDate, i)
            } else if endIntervalB > endIntervalA && startIntervalB < endIntervalA {
                self.updateEventConflictInfo(&sortedStartDate, i)
            }
        }
        
        return sortedStartDate
    }
    
    fileprivate func updateEventConflictInfo(_ events: inout [Event], _ index: Int) {
        events[index-1].hasConflicts = true
        events[index].hasConflicts = true
        let title = events[index].title
        events[index-1].conflictedTitles.insert(title)
        let prevTitle = events[index-1].title
        events[index].conflictedTitles.insert(prevTitle)
    }
    
    func handleConflictIconClick(_ event: Event) {
        guard event.conflictedTitles.count > 0 else { return }
        let titles = event.conflictedTitles
        self.view?.showConflictedEvent(titles)
    }
}
