//
//  ApiResponse.swift
//  DefaultCamDemo
//
//  Created by can.khac.nguyen on 3/20/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiResponse: Mappable {

    var message: String?
    var errors: [String: Any]?
    var code: Int?
    var data: ApiDataResponse?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        message <- map["message"]
        errors <- map["errors"]
        code <- map["code"]
        data <- map["data"]
    }

}
