//
//  TripEarningsTableViewCell.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 10/22/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit

class TripEarningsTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var rideTimeLabelOutlet: UILabel!
    @IBOutlet weak var dropoffAddressTextViewOutlet: UITextView!
    @IBOutlet weak var rideEarningsLabelOutlet: UILabel!
    
    // MARK: - Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(rideTime: String,
                   dropoffAddress: String,
                   rideEarnings: String) {
        
        self.rideTimeLabelOutlet.text = rideTime
        self.dropoffAddressTextViewOutlet.text = dropoffAddress
        self.rideEarningsLabelOutlet.text = rideEarnings
    }
    
    // MARK: - Helpers

}
