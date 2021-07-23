//
//  ViewController.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        EventService.getEvents { result in
            switch result {
            case .success(let events):
                print(events)
            case .failure(let error):
                print(error)
            }
        }
    }


}

