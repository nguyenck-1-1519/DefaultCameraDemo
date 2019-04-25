//
//  ApiUrlTableViewCell.swift
//  DefaultCamDemo
//
//  Created by Can Khac Nguyen on 4/25/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import UIKit

protocol ApiUrlTableViewCellDelegate: class {
    func onSetPrimaryButtonClicked(atIndex index: Int)
}

class ApiUrlTableViewCell: UITableViewCell {

    @IBOutlet weak var apiUrlLabel: UILabel!
    @IBOutlet weak var setPrimaryButton: UIButton!
    
    var cellIndex: Int!
    weak var delegate: ApiUrlTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onSetPrimaryButtonClicked(_ sender: Any) {
        setPrimaryButton.isEnabled = false
        delegate?.onSetPrimaryButtonClicked(atIndex: cellIndex)
    }
}
