//
//  UpcomingEventsPresenter.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

protocol UpcomingEventsView: AnyObject {
    func showEvents(_ eventDicts: [EventDict])
    func showError(_ errorMessage: String)
    func showConflictedEvent(_ title: String)
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
        var sorted = events.sorted(by: {
            $0.startFullDate.compare($1.startFullDate) == .orderedAscending
        })
        sorted = self.markConflicts(&sorted)
        return sorted
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
        for i in 0..<sorted.count-1 {
            let endIntervalA = sorted[i].endFullDate.timeIntervalSince1970
            let startIntervalB = sorted[i+1].startFullDate.timeIntervalSince1970
            let endIntervalB = sorted[i+1].endFullDate.timeIntervalSince1970
            
            if startIntervalB < endIntervalA && endIntervalA < endIntervalB {
                sorted[i].hasConflicts = true
                sorted[i+1].hasConflicts = true
                sorted[i].nextConflictedEventTitle = sorted[i+1].title
            } else if startIntervalB < endIntervalA && endIntervalA > endIntervalB {
                sorted[i].hasConflicts = true
                sorted[i+1].hasConflicts = true
                sorted[i].nextConflictedEventTitle = sorted[i+1].title
            }
        }
        
        return sorted
    }
    
    func handleConflictIconClick(_ event: Event) {
        guard let title = event.nextConflictedEventTitle else { return }
        self.view?.showConflictedEvent(title)
    }
}
