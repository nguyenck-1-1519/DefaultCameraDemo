//
//  StructDefine.swift
//  DefaultCamDemo
//
//  Created by Can Khac Nguyen on 4/25/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import Foundation

struct AlertTitle {
    static let error = "Error"
}

struct AlertMessage {
    static let fillUrl = "Please type Url first"
    static let addExistedUrl = "Url is existing"
    static let deletePrimaryUrl = "Cant delete primary Api Url"
}

struct UserDefaultsKey {
    static let primaryApiUrl = "PrimaryApiUrl"
    static let apiUrls = "ApiUrls"
}

struct Constant {
    static let defaultApiUrl = "http://192.168.19.18:9669/api/ocr"
    static let okTitle = "OK"
    static let deleteTitle = "Delete"
    static let deleteMultipleTitle = "Delete multiple"
    static let deletePromt = "Swipe to delete single cell"
}
