//
//  Utilities.swift
//  DefaultCamDemo
//
//  Created by can.khac.nguyen on 4/26/19.
//  Copyright © 2019 Can Khac Nguyen. All rights reserved.
//

import Foundation

class Utilites {

    static func getDataParam(fromArray contentData: [String]) -> Data {
        var resultString = "["
        for index in 0..<contentData.count {
            resultString += "\"\(contentData[index])\""
            if index != contentData.count - 1 {
                resultString += ","
            }
        }
        resultString += "]"
        return resultString.data(using: .utf8) ?? Data()
    }

}
