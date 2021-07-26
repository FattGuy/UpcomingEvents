//
//  AppStyle.swift
//  UpcomingEvents
//
//  Created by Feng Chang on 7/23/21.
//

import UIKit

class AppStyle {
    static let conflictIcon = UIImage(named: "ic-conflict-warning")
}

extension UIColor {
    static func backgroundGray() -> UIColor {
        return .systemGroupedBackground
    }
    
    static func facebookBlue() -> UIColor {
        return UIColor(hex: "3b5998")
    }
    
    static func facebookGray() -> UIColor {
        return UIColor(hex: "DFE3EE")
    }
    
    static func facebookBlack() -> UIColor {
        return UIColor(hex: "000000")
    }
}
