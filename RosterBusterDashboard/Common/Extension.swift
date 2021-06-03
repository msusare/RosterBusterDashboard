//
//  Extension.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 30/05/21.
//

import Foundation
import UIKit

//MARK: - Story
// Extension of Sotry Entity for formating
extension Story {
    func toDictionaryObject() -> [[String: Any]] {
        var result = [String: Any]()
        result["Flightnr"] = self.flightnr
        result["Aircraft Type"] = self.aircraftType
        result["Captain"] = self.captain
        result["First Officer"] = self.firstOfficer
        result["Flight Attendant"] = self.flightAttendant
        result["Tail"] = self.tail
        result["Date"] = self.date
        result["Departure"] = self.departure
        result["Destination"] = self.destination
        result["Time Depart"] = self.timeDepart
        result["Time Arrive"] = self.timeArrive
        result["Duty Code"] = self.dutyCode
        result["Duty ID"] = self.dutyID
        
        let arrayResult = result.sorted {
            $0.key < $1.key
        }.map({[$0.key: $0.value]})
        
        return arrayResult
    }
}

//MARK: - UIView
extension UIView {
    func rotate(degrees: CGFloat) {

        let degreesToRadians: (CGFloat) -> CGFloat = { (degrees: CGFloat) in
            return degrees / 180.0 * CGFloat.pi
        }
        self.transform =  CGAffineTransform(rotationAngle: degreesToRadians(degrees))
    }
}

//MARK:- TablewView
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 18)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
