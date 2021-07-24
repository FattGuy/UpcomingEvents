//
//  EventService.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import Foundation

protocol EventProvider {
    static func getEvents(completion: @escaping (Result<[Event]?, Error>) -> Void)
}

class EventService: EventProvider {
    static func getEvents(completion: @escaping (Result<[Event]?, Error>) -> Void) {
        do {
            let filename = "mock"
            if let bundlePath = Bundle.main.path(forResource: filename, ofType: "json"), let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let decodedData = try JSONDecoder().decode([Event].self,
                                                           from: jsonData)
                completion(.success(decodedData))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
