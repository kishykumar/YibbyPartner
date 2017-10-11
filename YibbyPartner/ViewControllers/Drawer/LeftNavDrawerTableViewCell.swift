//
//  LeftNavDrawerTableViewCell.swift
//  Example
//
//  Created by Kishy Kumar on 2/19/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack

class LeftNavDrawerTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var menuItemLabel: UILabel!
    
    @IBOutlet weak var menuItemIconLabelOutlet: UILabel!
    
    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Configure

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
