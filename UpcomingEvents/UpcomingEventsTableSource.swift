//
//  UpcomingEventsTableSource.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import UIKit

class UpcomingEventsTableSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var events: [Event]
    var tableView: UITableView
    
    init(with tableView: UITableView, events: [Event] = []) {
        self.events = events
        self.tableView = tableView
        self.tableView.register(UINib(nibName: "UpcomingEventCell", bundle: nil), forCellReuseIdentifier: "UpcomingEventCell")
        
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorStyle = .none
    }
    
    func updateDataSource(with events: [Event]) {
        self.events.removeAll()
        self.events = events
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingEventCell", for: indexPath) as! UpcomingEventCell
        cell.setup(events[indexPath.row])
        return cell
    }
}
