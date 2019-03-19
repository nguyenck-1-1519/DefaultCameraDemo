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
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    var contentImage: UIImage!
    @IBOutlet weak var contentImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView.image = contentImage
        configButtons()
    }
    
    private func configButtons() {
        let dismissImage = #imageLiteral(resourceName: "exitButton").withRenderingMode(.alwaysTemplate)
        let uploadImage = #imageLiteral(resourceName: "UploadButton").withRenderingMode(.alwaysTemplate)
        dismissButton.setImage(dismissImage, for: .normal)
        uploadButton.setImage(uploadImage, for: .normal)
        dismissButton.tintColor = .blue
        uploadButton.tintColor = .blue
    }
    
    @IBAction func onDismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onUploadButtonClicked(_ sender: Any) {
        // implement api
        guard let image = contentImageView.image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "file", fileName: "image.jpeg", mimeType: "")
                multipartFormData.append("uploadImage".data(using: String.Encoding.utf8) ?? Data(), withName: "folder")
        },
            to: "http://192.168.15.71:8800/upload.php",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }

}
