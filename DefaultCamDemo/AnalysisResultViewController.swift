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

    @IBOutlet weak var analysisResultData1TextView: UITextView!
    @IBOutlet weak var analysisResultData2TextView: UITextView!
    @IBOutlet weak var stackView: UIStackView!

    var analysisResponse: ApiResponse!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let apiResponse = analysisResponse.data, let formType = analysisResponse.data?.formType else {
            return
        }
        analysisResultData1TextView.text = getDataString(data: apiResponse.data1)
        analysisResultData2TextView.text = getDataString(data: apiResponse.data2)
        stackView.axis = formType == 1 ? .vertical : .horizontal

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
