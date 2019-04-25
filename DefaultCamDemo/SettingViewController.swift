//
//  SettingViewController.swift
//  DefaultCamDemo
//
//  Created by Can Khac Nguyen on 4/25/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var apiUrlTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addUrlButton: UIButton!
    
    var apiUrls = AppInfo.shared.apiUrls ?? [Constant.defaultApiUrl]
    var isTableViewEditing = false {
        didSet {
            tableView.isEditing = isTableViewEditing
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // config tableview
        tableView.allowsMultipleSelectionDuringEditing = true
        
        // config navigation bar
        let rightBarButtonItem = UIBarButtonItem(title: Constant.deleteMultipleTitle, style: .plain, target: self, action: #selector(handleDeleteMultipleAction))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addUrlButton.layer.cornerRadius = addUrlButton.bounds.height / 2
        addUrlButton.clipsToBounds = true
    }
    
    // MARK: handle action
    @objc func handleDeleteMultipleAction() {
        navigationItem.rightBarButtonItem?.tintColor = isTableViewEditing ? nil : .red
        navigationItem.rightBarButtonItem?.title = isTableViewEditing ? Constant.deleteMultipleTitle : Constant.deleteTitle
        // delete selected rows
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows, isTableViewEditing {
            var apiUrlsSelected = [String]()
            // check exist primary api
            for indexPath in selectedIndexPaths {
                if apiUrls[indexPath.row] == AppInfo.shared.primaryApiUrl {
                    showAlert(withTitle: AlertTitle.error, message: AlertMessage.deletePrimaryUrl) {}
                    isTableViewEditing = !isTableViewEditing
                    return
                }
                apiUrlsSelected.append(apiUrls[indexPath.row])
            }
            // remove selected item
            for apiUrlSelected in apiUrlsSelected {
                for index in 0..<apiUrls.count where apiUrls[index] == apiUrlSelected {
                    apiUrls.remove(at: index)
                    break
                }
            }
            // submit deleted item
            AppInfo.shared.sync(apiUrls: apiUrls)
            tableView.deleteRows(at: selectedIndexPaths, with: .automatic)
        }
        isTableViewEditing = !isTableViewEditing
    }
    
    @IBAction func onAddUrlButtonClicked(_ sender: Any) {
        guard let apiUrlAdding = apiUrlTextfield.text, !apiUrlAdding.isEmpty else {
            showAlert(withTitle: AlertTitle.error, message: AlertMessage.fillUrl) {}
            return
        }
        // check exist
        for apiUrl in apiUrls {
            if apiUrl == apiUrlAdding {
                showAlert(withTitle: AlertTitle.error, message: AlertMessage.addExistedUrl) {}
                return
            }
        }
        // validate done >> add to array
        apiUrls.append(apiUrlAdding)
        AppInfo.shared.sync(apiUrls: apiUrls)
        tableView.reloadData()
    }
}

extension SettingViewController: ApiUrlTableViewCellDelegate {
    func onSetPrimaryButtonClicked(atIndex index: Int) {
        // if primary url old cell is visible >> set enable for primary url old cell
        for cell in tableView.visibleCells {
            if let cell = cell as? ApiUrlTableViewCell,
                apiUrls[cell.cellIndex] == AppInfo.shared.primaryApiUrl {
                cell.setPrimaryButton.isEnabled = true
                break
            }
        }
        // submit new primary api url
        AppInfo.shared.sync(primaryApiUrl: apiUrls[index])
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ApiUrlTableViewCell") as? ApiUrlTableViewCell else {
            return UITableViewCell()
        }
        cell.cellIndex = indexPath.row
        cell.apiUrlLabel.text = apiUrls[indexPath.row]
        cell.delegate = self
        cell.setPrimaryButton.isEnabled = !(apiUrls[indexPath.row] == AppInfo.shared.primaryApiUrl)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // check primary api or not
            if apiUrls[indexPath.row] == AppInfo.shared.primaryApiUrl {
                showAlert(withTitle: AlertTitle.error, message: AlertMessage.deletePrimaryUrl) {}
                return
            }
            apiUrls.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            AppInfo.shared.sync(apiUrls: apiUrls)
        }
    }
}
