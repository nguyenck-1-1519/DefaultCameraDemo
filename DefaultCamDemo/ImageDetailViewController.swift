//
//  ImageDetailViewController.swift
//  DefaultCamDemo
//
//  Created by Can Khac Nguyen on 3/19/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ImageDetailViewController: UIViewController {
    
    var contentImage: UIImage!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var backDropView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView.image = contentImage
        configButtons()
        showIndicator(false)
    }
    
    private func configButtons() {
        let uploadImage = #imageLiteral(resourceName: "UploadButton").withRenderingMode(.alwaysTemplate)
        let rightUploadButton = UIBarButtonItem(image: uploadImage, style: .plain, target: self,
                                               action: #selector(uploadImageToServer))
        navigationItem.rightBarButtonItem = rightUploadButton
    }

    private func showIndicator(_ isShow: Bool) {
        isShow ? indicator.startAnimating() : indicator.stopAnimating()
        backDropView.isHidden = !isShow
    }

    private func showResult(response: ApiResponse) {
        guard let resultController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AnalysisResultViewController") as? AnalysisResultViewController else {
            return
        }
        resultController.analysisResponse = response
        self.navigationController?.pushViewController(resultController, animated: true)
    }

    @objc private func uploadImageToServer() {
        // implement api
        guard let image = contentImageView.image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let fileName = "image_\(Date().timeIntervalSince1970).jpeg"
        showIndicator(true)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: "image/png")
        },
            to: AppInfo.shared.primaryApiUrl,
            encodingCompletion: { [weak self] encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            debugPrint(response)
                            self?.showIndicator(false)
                            guard let statusCode = response.response?.statusCode else {
                                return
                            }
                            if statusCode == 200 {
                                guard let apiResponse = Mapper<ApiResponse>().map(JSONObject: value) else {
                                    return
                                }
                                self?.showResult(response: apiResponse)
                            } else {
                                let apiResponse = Mapper<ApiResponse>().map(JSONObject: value)
                                self?.showAlert(isSuccess: false, message: apiResponse?.message)
                            }
                        case .failure(let error):
                            self?.showAlert(isSuccess: false, message: error.localizedDescription)
                            print(error.localizedDescription)
                        }
                    }
                case .failure(let encodingError):
                    self?.showIndicator(false)
                    print(encodingError)
                    self?.showAlert(isSuccess: false)
                }
        })
    }

    private func showAlert(isSuccess: Bool, message: String? = nil) {
        let title = isSuccess ? "Success" : "Error"
        var messageDisplay = isSuccess ? "Upload success" : "Upload fail"
        if let message = message {
            messageDisplay = message
        }
        let alertController = UIAlertController(title: title, message: messageDisplay, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
