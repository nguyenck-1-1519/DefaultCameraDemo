//
//  ParameterTableViewCell.swift
//  DefaultCamDemo
//
//  Created by can.khac.nguyen on 4/26/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import UIKit

class ParameterTableViewCell: UITableViewCell {

    static let identifier = String(describing: ParameterTableViewCell.self)

    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
}
