//
//  UpcomingEventsViewController.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import UIKit

class UpcomingEventsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var presenter: UpcomingEventPresenter?
    var tableSource: UpcomingEventsTableSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        presenter = UpcomingEventPresenter(with: self)
        tableSource = UpcomingEventsTableSource(with: tableView, presenter: presenter)
        presenter?.start()
        
    }
}

extension UpcomingEventsViewController: UpcomingEventsView {
    func showEvents(_ eventDicts: [EventDict]) {
        self.tableSource?.updateDataSource(with: eventDicts)
    }
    
    func showError(_ errorMessage: String) {
        let alert = UIAlertController(title: "An error occured", message: errorMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] action in
            self?.presenter?.getEvents()
        }))
        
        present(alert, animated: true)
    }
    
    func showConflictedEvent(_ title: String) {
        let alert = UIAlertController(title: "Event", message: title, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

