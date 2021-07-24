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
    
    func setup(_ event: Event) {
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = UIColor.backgroundGray()
        titleLabel.text = event.title
        startDateLabel.text = event.start
        endDateLabel.text = event.end
        conflictButton.setImage(AppStyle.conflictIcon, for: .normal)
    }
    
    @IBAction func tappedConflictButton(_ sender: Any) {
        //TODO:
    }
}
