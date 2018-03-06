//
//  PassesTableviewCell.swift
//  ISS-Passes
//
//  Created by Ravi on 06/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class PassesTableviewCell: UITableViewCell {

    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var riseTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
