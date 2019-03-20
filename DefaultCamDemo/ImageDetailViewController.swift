//
//  ImageDetailViewController.swift
//  DefaultCamDemo
//
//  Created by Can Khac Nguyen on 3/19/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import UIKit
import Alamofire

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

    private func showResult(response: DataResponse<Any>) {
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
                multipartFormData.append(imageData, withName: "file", fileName: fileName, mimeType: "image/jpeg")
                multipartFormData.append("uploadImage".data(using: String.Encoding.utf8) ?? Data(), withName: "folder")
        },
            to: "http://192.168.15.71:8800/upload.php",
            encodingCompletion: { [weak self] encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        self?.showIndicator(false)
                        debugPrint(response)
                        self?.showResult(response: response)
                    }
                case .failure(let encodingError):
                    self?.showIndicator(false)
                    print(encodingError)
                    self?.showAlert(isSuccess: false)
                }
        })
    }

    private func showAlert(isSuccess: Bool) {
        let title = isSuccess ? "Success" : "Error"
        let message = isSuccess ? "Upload image success" : "There is something wrong"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
