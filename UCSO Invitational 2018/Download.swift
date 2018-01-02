//
//  Network-and-Storage.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 1/1/18.
//  Copyright © 2018 bayser. All rights reserved.
//

import Foundation

class Download {
    static let baseFileFolder = "https://github.com/oortsang/UCSO-Invitational-2018/tree/master/Updatable%20Files/"
    static let buildEventURL = baseFileFolder + "BuildEvents.csv"
    static let testEventURL = baseFileFolder + "TestEvents.csv"
    static let homeroomURL = baseFileFolder + "Homerooms.csv"
/*
    static func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessConfig = URLSessionConfiguration.default
        let sess = URLSession(configuration: sessConfig)
        let request = try! URLRequest(url: url, cachePolicy:  .reloadIgnoringCacheData) //???
     
        let task = sess.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                //success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print ("Success! \(statusCode)")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    copmletion()
                } catch (let writeError) {
                    print("Error!!")
                }
            } else {
                print("Failure!!")
            }
        }
        task.resume()
    }
*/
}


