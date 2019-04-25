//
//  UIViewController+Ext.swift
//  DefaultCamDemo
//
//  Created by Can Khac Nguyen on 4/25/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(withTitle title: String, message: String, okAction ok: (()->Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constant.okTitle, style: .default) { _ in
            ok?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
