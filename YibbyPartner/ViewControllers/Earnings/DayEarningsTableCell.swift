//
//  DayEarningsTableCell.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/13/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit

class DayEarningsTableCell : UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var dayNameLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var earningsLabelOutlet: UILabel!
    @IBOutlet weak var totalTripsLabelOutlet: UILabel!
    @IBOutlet weak var onlineTimeLabelOutlet: UILabel!
    
    // MARK: Setup functions
    
    func configure(dayName: String,
                   date: String,
                   earnings: String,
                   totalTrips: String,
                   onlineTime: String) {
        
        self.dayNameLabelOutlet.text = dayName
        self.dateLabelOutlet.text = date
        
        self.earningsLabelOutlet.text = earnings
        self.totalTripsLabelOutlet.text = totalTrips
        self.onlineTimeLabelOutlet.text = onlineTime
    }
}
