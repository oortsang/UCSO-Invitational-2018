//
//  CSVtoArray.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 1/1/18.
//  Copyright © 2018 bayser. All rights reserved.
//

import Foundation
import CoreData



func getCol(array: [[Any]], col: Int) -> [Any]? {
    var tmp: [Any] = []
    for row in array {
        tmp.append(row[col])
    }
    return tmp
}


class CSVFile {
    static let baseFileFolder = "https://raw.githubusercontent.com/oortsang/UCSO-Invitational-2018/master/Updatable%20Files/"
    static let buildEventAddress = baseFileFolder + "BuildEvents.csv"
    static let testEventAddress = baseFileFolder + "TestEvents.csv"
    static let homeroomAddress = baseFileFolder + "Homerooms.csv"

    var data: [[String]] = [[]]
    var file: String = ""
    
    //initializers
    init() {}
    init(input: [[String]]) {
        data = input
    }
    init (lookup: String) {
        self.load(fileName: lookup)
    }
    
    //takes the text info from a CSV and turns it into a 2D array
    //2D array gets dumped into the class
    func parse() {
        if self.file == "" {
            return
        }
        let rows: [String] = file.components(separatedBy: "\r\n")
        if rows.count > 1 { //want to make sure it's not just an empty string
            var data: [[String]] = []
            for row in rows {
                let content = row.components(separatedBy: ",")
                if content != [""] {
                    data.append(content)
                }
            }
            self.data = data
        } //otherwise, leave it the same
    }
    
    //appDelegate is defined elsewhere
    static let fileContext = appDelegate.persistentContainer.viewContext
    static let fileRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Files")
    
    //storing these csv guys
    //tell it what name to save under
    func save(name: String) {
        //don't want to overwrite existing things if there is nothing of use in the file at the moment
        if (self.file == "") {
            print("File not saved...")
            return
        }
        
        self.clear(fileName: name) //clean up any mess
        let newFile = NSEntityDescription.insertNewObject(forEntityName: "Files", into: CSVFile.fileContext)
        newFile.setValue (name, forKey: "fileName") //make an entry title
        newFile.setValue(self.file, forKey: "data") //put the string in it

        //print("HOORAY! self.file:  \(self.file)")

        do {
            try CSVFile.fileContext.save()
        }  catch {
            print("Something went wrong with saving a file")
        }



    }
    //load from disk
    func load(fileName: String) {
        CSVFile.fileRequest.returnsObjectsAsFaults = false
        let tmp = CSVFile.fileRequest.predicate
        CSVFile.fileRequest.predicate = NSPredicate(format: "fileName = %@", fileName)
        do {
            let results = try CSVFile.fileContext.fetch(CSVFile.fileRequest)
            //print("I have this many results: ",results.count)
            if results.count > 0 {
                let result = results.first
                if let loadedData = (result as! NSManagedObject).value(forKey:"data") {
                    self.file = loadedData as! String
                    self.parse()
                }
            }
        }
        catch {
            print("Something went wrong with the request...")
        }
        CSVFile.fileRequest.predicate = tmp
        
        
    }
    //deletes every result when searching <name> in the fileRequest
    func clear(fileName: String) {
        CSVFile.fileRequest.returnsObjectsAsFaults = false
        do {
            let results = try CSVFile.fileContext.fetch(CSVFile.fileRequest) as? [NSManagedObject]
            if results!.count > 0 {
                
                for object in results as [NSManagedObject]! {
                    //if object.value(forKey: "fileName") as! String == fileName {
                    if (object.value(forKey: "fileName") as? String) == fileName {
                        CSVFile.fileContext.delete(object)
                    }
                }
            }
        } catch {
            print("Something went wrong clearing out all the teams from disk")
        }
    }
    
    //clear all files from disk
    static func clearAll() -> Void {
        do {
            let results = try CSVFile.fileContext.fetch(fileRequest) as? [NSManagedObject]
            if results!.count > 0 {
                //delete all results
                for object in results! {
                    //print("Removed \(object)")
                    CSVFile.fileContext.delete(object)
                }
            }
        } catch {
            print("Something went wrong clearing out all the files from disk")
        }
    }
    
    //downloads a file from the source URL and deposits into the object it's in
    func downloadFile(sourceURL: String) {
        let url = URL(string: sourceURL)
        let task = URLSession.shared.downloadTask(with: url!) { loc, resp, error in
            if let error = error {
                print("Error: \(error); not updated")
                return
            }
            guard let httpResponse = resp as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    return
            }
            guard let data = try? Data(contentsOf: loc!) , error == nil else {return}
            //self.file = (String(data: data, encoding: .utf8))!
            let tmpfile = (String(data: data, encoding: .utf8))!
            if tmpfile == "" {
                return
            }
            self.file = tmpfile
            print("This is such a cool file! \(self.file)")
            self.parse()
            self.sendDownloadNotification()
        }
        task.resume()
    }
    func sendDownloadNotification() -> Void {
        NotificationCenter.default.post(name: .downloadFinished, object: nil)
    }
}
