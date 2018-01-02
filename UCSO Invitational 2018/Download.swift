//
//  Network-and-Storage.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 1/1/18.
//  Copyright © 2018 bayser. All rights reserved.
//

import Foundation

class Download {
    static let baseFileFolder = "https://rawgit.com/oortsang/UCSO-Invitational-2018/master/Updatable%20Files/"
    static let buildEventAddress = baseFileFolder + "BuildEvents.csv"
    static let testEventAddress = baseFileFolder + "TestEvents.csv"
    static let homeroomAddress = baseFileFolder + "Homerooms.csv"
    
    init(){return}
    
    var file: String = ""
    
    //downloads a file from the source URL and deposits into the class it's in
    func downloadFile(sourceURL: String) {
        let url = URL(string: sourceURL)
        let task = URLSession.shared.downloadTask(with: url!) { loc, resp, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = resp as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            guard let data = try? Data(contentsOf: loc!) , error == nil else {return}
            self.file = (String(data: data, encoding: .utf8))!
            print(self.file)
        }
        task.resume()
    }
}

