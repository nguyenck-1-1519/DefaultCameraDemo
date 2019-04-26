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

    var analysisResponseString: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        analysisResultTextView.text = analysisResponseString

        // add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapAction(recognizer:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapAction(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    private func getDataString(data: [String]?) -> String {
        var result = ""
        guard let data = data else {
            return result
        }
        for message in data {
            result += message + "\n"
        }
        return result
    }

}
