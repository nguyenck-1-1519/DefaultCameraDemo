//
//  AnalysisResultViewController.swift
//  DefaultCamDemo
//
//  Created by can.khac.nguyen on 3/20/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class AnalysisResultViewController: UIViewController {

    @IBOutlet weak var analysisResultTextView: UITextView!

    var analysisResponse: DataResponse<Any>!

    override func viewDidLoad() {
        super.viewDidLoad()
        analysisResultTextView.text = "\(analysisResponse.response)"
    }

}
