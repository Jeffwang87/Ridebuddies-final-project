//
//  RideTableViewCell.swift
//  UberShare
//
//  Created by wxt on 4/20/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var OriginLabel: UILabel!
    @IBOutlet weak var DestinationLabel: UILabel!
    @IBOutlet weak var LeavingTimeLabel: UILabel!
    var ride: Ride!
    var stringformatter = DateFormatter()
    
    func configureCell(ride:Ride){
        NameLabel.text = ride.name
        OriginLabel.text = ride.originname
        DestinationLabel.text = ride.destinationname
        stringformatter.dateFormat = "MMM, dd, y h:mm a"
        LeavingTimeLabel.text = stringformatter.string(from: ride.Time)
    }
}
