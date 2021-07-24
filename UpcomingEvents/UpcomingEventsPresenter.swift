//
//  UpcomingEventsPresenter.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

protocol UpcomingEventsView: AnyObject {
    func showEvents(_ eventDicts: [EventDict])
    func showError(_ errorMessage: String)
}

protocol UpcomingEventPresentation {
    func getEvents()
}

class UpcomingEventPresenter {
    
    weak var view: UpcomingEventsView?
    var service: EventProvider.Type = EventService.self
    var eventsDict: [String: [Event]]
    
    init(with view: UpcomingEventsView) {
        self.view = view
        self.eventsDict = [:]
    }
    
    func start() {
        self.getEvents()
    }
    
    func getEvents() {
        service.getEvents { [weak self] (result) in
            switch result {
            case .success(let events):
                self?.sortEvents(events ?? [])
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func sortEvents(_ events: [Event]) {
        self.groupEvents(events.sorted(by: {
            $0.startFullDate.compare($1.startFullDate) == .orderedAscending
        }))
    }
    
    func groupEvents(_ events: [Event]) {
        eventsDict = Dictionary(grouping: events, by: { $0.startDate.toString(.monthDayYear) ?? "" })
        
        var eventDicts = [EventDict]()
        
        for dict in eventsDict.sorted(by: { $0.key.localizedCompare($1.key) == .orderedAscending }) {
            let eventDict = EventDict(title: dict.key, events: dict.value)
            eventDicts.append(eventDict)
        }
        
        self.view?.showEvents(eventDicts)
    }
}
