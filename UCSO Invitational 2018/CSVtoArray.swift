//
//  CSVtoArray.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 1/1/18.
//  Copyright © 2018 bayser. All rights reserved.
//

import Foundation

//takes the text info from a CSV and turns it into a 2D array
func readCSV(fileContents: String) -> [[String]]? {
    let rows: [String] = fileContents.components(separatedBy: "\n")
    if rows.count > 0 {
        var data: [[String]] = []
        for (i, row) in rows.enumerated() {
            data[i] = row.components(separatedBy: ",")
        }
        return data
    } else {
        return [[""]]
    }
}
