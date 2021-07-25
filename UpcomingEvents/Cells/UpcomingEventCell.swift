//
//  UpcomingEventCell.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import UIKit

class UpcomingEventCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var conflictButton: UIButton!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    private var presenter: UpcomingEventPresentation?
    private var event: Event?
    
    func setup(_ event: Event, _ presenter: UpcomingEventPresentation?) {
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = UIColor.backgroundGray()
        titleLabel.text = event.title
        startDateLabel.text = event.startFullDateString
        endDateLabel.text = event.endFullDateString
        conflictButton.isHidden = !(event.hasConflicts ?? false)
        conflictButton.setImage(AppStyle.conflictIcon, for: .normal)
        self.event = event
        self.presenter = presenter
    }
    
    @IBAction func tappedConflictButton(_ sender: Any) {
        guard let event = self.event else { return }
        self.presenter?.handleConflictIconClick(event)
    }
}
