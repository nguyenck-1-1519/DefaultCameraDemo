//
//  ApiDataResponse.swift
//  DefaultCamDemo
//
//  Created by can.khac.nguyen on 3/20/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiDataResponse: Mappable {

    var formType: Int?
    var formName: String?
    var data1: [String]?
    var data2: [String]?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        formType <- map["form_type"]
        formName <- map["form_name"]
        data1 <- map["data1"]
        data2 <- map["data2"]
    }

}
