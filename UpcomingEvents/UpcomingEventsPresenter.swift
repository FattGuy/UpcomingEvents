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
    
    func sortEvents(_ events: [Event]) -> [Event] {
        var sortedWithEndDate = events.sorted(by: {
            $0.endFullDate.compare($1.endFullDate) == .orderedAscending
        })
        sortedWithEndDate = self.markConflicts(&sortedWithEndDate)
        
        var sortedWithStartDate = sortedWithEndDate.sorted(by: {
            $0.startFullDate.compare($1.startFullDate) == .orderedAscending
        })
        sortedWithStartDate = self.markConflicts(&sortedWithStartDate)
        
        return sortedWithStartDate
    }
    
    func groupEvents(_ events: [Event]) {
        let eventsDict = Dictionary(grouping: events, by: { $0.startDate.toString(.monthDayYear) ?? "" })
        
        var eventDicts = [EventDict]()
        
        for dict in eventsDict.sorted(by: { $0.key.localizedCompare($1.key) == .orderedAscending }) {
            let eventDict = EventDict(title: dict.key, events: dict.value)
            eventDicts.append(eventDict)
        }
        
        self.view?.showEvents(eventDicts)
    }
    
    func markConflicts(_ sorted: inout [Event]) -> [Event] {
        //1. a.start < b.start, a.end < b.end, a.end > b.start
        //2. a.start > b.start, a.start < b.end
        for i in 1..<sorted.count {
            let startIntervalA = sorted[i-1].startFullDate.timeIntervalSince1970
            let endIntervalA = sorted[i-1].endFullDate.timeIntervalSince1970
            let startIntervalB = sorted[i].startFullDate.timeIntervalSince1970
            let endIntervalB = sorted[i].endFullDate.timeIntervalSince1970
            
            if startIntervalA == startIntervalB && endIntervalA == endIntervalB {
                sorted[i-1].hasConflicts = true
                sorted[i].hasConflicts = true
                let title = sorted[i].title
                sorted[i-1].conflictedTitles.insert(title)
                let prevTitle = sorted[i-1].title
                sorted[i].conflictedTitles.insert(prevTitle)
            } else if startIntervalB < endIntervalA && endIntervalA < endIntervalB {
                sorted[i-1].hasConflicts = true
                sorted[i].hasConflicts = true
                let title = sorted[i].title
                sorted[i-1].conflictedTitles.insert(title)
                let prevTitle = sorted[i-1].title
                sorted[i].conflictedTitles.insert(prevTitle)
            } else if startIntervalB < endIntervalA && endIntervalA > endIntervalB {
                sorted[i-1].hasConflicts = true
                sorted[i].hasConflicts = true
                let title = sorted[i].title
                sorted[i-1].conflictedTitles.insert(title)
                let prevTitle = sorted[i-1].title
                sorted[i].conflictedTitles.insert(prevTitle)
            }
        }
        
        return sorted
    }
    
    func handleConflictIconClick(_ event: Event) {
        //TODO: Find the way to fix this - event might have multiple conflicted events
        guard event.conflictedTitles.count > 0 else { return }
        let titles = event.conflictedTitles
        self.view?.showConflictedEvent(titles)
    }
}
