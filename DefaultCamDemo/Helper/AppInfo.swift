//
//  AppInfo.swift
//  DefaultCamDemo
//
//  Created by Can Khac Nguyen on 4/25/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import Foundation

class AppInfo {
    static let shared = AppInfo()
    
    var apiUrls: [String]!
    var primaryApiUrl: String
    var listParameter: [String]!
    let userDefaults = UserDefaults.standard
    
    init() {
        apiUrls = userDefaults.object(forKey: UserDefaultsKey.apiUrls) as? [String] ?? [Constant.defaultApiUrl]
        primaryApiUrl = userDefaults.string(forKey: UserDefaultsKey.primaryApiUrl) ?? Constant.defaultApiUrl
        listParameter = userDefaults.object(forKey: UserDefaultsKey.listParameter) as? [String] ?? Constant.fields
    }
    
    func sync(primaryApiUrl: String? = nil, apiUrls: [String]? = nil, parameters: [String]? = nil) {
        if let primaryApiUrl = primaryApiUrl {
            self.primaryApiUrl = primaryApiUrl
            userDefaults.set(primaryApiUrl, forKey: UserDefaultsKey.primaryApiUrl)
        }
        if let apiUrls = apiUrls {
            self.apiUrls = apiUrls
            userDefaults.set(apiUrls, forKey: UserDefaultsKey.apiUrls)
        }
        if let parameters = parameters {
            self.listParameter = parameters
            userDefaults.set(parameters, forKey: UserDefaultsKey.listParameter)
        }
    }
}
