//
//  Int-Formatting.swift
//  Friend Zone
//
//  Created by Sarvad shetty on 2/9/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    func timeString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .positional
        
        let formattedString = formatter.string(from: TimeInterval(self)) ?? "0"
        
        if formattedString == "0" {
            return "GMT"
        } else {
            if formattedString.hasPrefix("-") {
                return "GMT\(formattedString)"
            } else {
                return "GMT+\(formattedString)"
            }
        }
    }
}
