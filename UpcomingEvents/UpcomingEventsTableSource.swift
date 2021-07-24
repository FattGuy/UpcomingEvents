//
//  UpcomingEventsTableSource.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import UIKit

class UpcomingEventsTableSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var eventDicts: [EventDict]
    var tableView: UITableView
    var presenter: UpcomingEventPresentation?
    
    init(with tableView: UITableView, eventDicts: [EventDict] = [], presenter: UpcomingEventPresentation? = nil) {
        self.eventDicts = eventDicts
        self.tableView = tableView
        self.tableView.register(UINib(nibName: "UpcomingEventCell", bundle: nil), forCellReuseIdentifier: "UpcomingEventCell")
        self.presenter = presenter
        
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    
    func updateDataSource(with eventDicts: [EventDict]) {
        self.eventDicts.removeAll()
        self.eventDicts = eventDicts
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventDicts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDicts[section].events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingEventCell", for: indexPath) as! UpcomingEventCell
        let event = eventDicts[indexPath.section].events[indexPath.row]
        cell.setup(event, self.presenter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = eventDicts[section].title
        return title
    }
}
