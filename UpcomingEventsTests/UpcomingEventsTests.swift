//
//  UpcomingEventsTests.swift
//  UpcomingEventsTests
//
//  Created by Feng Chang on 7/23/21.
//

import XCTest
@testable import UpcomingEvents

class UpcomingEventPresenterTests: XCTestCase {
    
    private var view: MockUpcomingEventsView!
    private var presenter: UpcomingEventPresenter!
        
    override func setUpWithError() throws {
        view = MockUpcomingEventsView()
        presenter = UpcomingEventPresenter(with: view)
        presenter.service = MockEventService.self
    }
    
    override func tearDownWithError() throws {
        view = nil
        presenter = nil
        MockEventService.tearDown()
    }
    
    func testStart() throws {
        presenter.start()
        
        XCTAssertTrue(1 > 0)
    }
}

extension UpcomingEventPresenterTests {
    
    private class MockUpcomingEventsView: UpcomingEventsView {
        func showEvents(_ eventDicts: [EventDict]) {
            
        }
        
        func showError(_ errorMessage: String) {
            
        }
        
        func showConflictedEvent(_ titles: Set<String>) {
            
        }
    }
    
    private class MockEventService: EventProvider {
        
        // Use a static helper, since our services are static classes.  This ensures everything is cleared on tearDown()
        class MockEventServiceHelper {
//            var commentaryCategories = [CommentaryCategory]()
        }
        
        static var helper = MockEventServiceHelper()
        
        static func tearDown() {
            helper = MockEventServiceHelper()
        }
        
        static func getEvents(completion: @escaping (Result<[Event]?, Error>) -> Void) {
            
        }
    }
}
