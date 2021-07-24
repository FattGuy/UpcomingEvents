//
//  UpcomingEventsPresenter.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

protocol UpcomingEventsView: AnyObject {
    func showEvents(_ events: [Event])
    func showError(_ errorMessage: String)
}

protocol UpcomingEventPresentation {
    func getEvents()
}

class UpcomingEventPresenter {
    
    weak var view: UpcomingEventsView?
    var service: EventProvider.Type = EventService.self
    
    init(with view: UpcomingEventsView) {
        self.view = view
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
        var events = events
        events = events.sorted(by: {
            $0.startDate.compare($1.startDate) == .orderedAscending
        })
        
        self.view?.showEvents(events ?? [])
    }
}
