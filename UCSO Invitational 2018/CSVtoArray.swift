//
//  CSVtoArray.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 1/1/18.
//  Copyright © 2018 bayser. All rights reserved.
//

import Foundation
import CoreData


class CSVFile {
    static let baseFileFolder = "https://rawgit.com/oortsang/UCSO-Invitational-2018/master/Updatable%20Files/"
    static let buildEventAddress = baseFileFolder + "BuildEvents.csv"
    static let testEventAddress = baseFileFolder + "TestEvents.csv"
    static let homeroomAddress = baseFileFolder + "Homerooms.csv"

    var data: [[String]] = [[""]]
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
    func readCSV(fileContents: String) {
        let rows: [String] = fileContents.components(separatedBy: "\n")
        if rows.count > 0 {
            var data: [[String]] = []
            for (i, row) in rows.enumerated() {
                data[i] = row.components(separatedBy: ",")
            }
            self.data = data
        } else {
            return
        }
    }
    
    //appDelegate is defined elsewhere
    static let fileContext = appDelegate.persistentContainer.viewContext
    static let fileRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Files")
    //storing these csv guys
    //tell it what name to save under
    func save(name: String) {
        self.clear(name: name)
        let newFile = NSEntityDescription.insertNewObject(forEntityName: "Files", into: CSVFile.fileContext)
        newFile.setValue (name, forKey: "file")
        do {
            try CSVFile.fileContext.save()
        }
        catch {
            print("Something went wrong with saving a file")
        }
    }
    //load from disk
    func load(fileName: String) {
        CSVFile.fileRequest.returnsObjectsAsFaults = false
        let tmp = CSVFile.fileRequest.predicate
        CSVFile.fileRequest.predicate = NSPredicate(format: "file = %@", fileName)
        do {
            let results = try CSVFile.fileContext.fetch(CSVFile.fileRequest)
            if results.count > 0 {
                let result = results.first
                if let loadedData = (result as AnyObject).value(forKey:"file") as? String {
                    self.file = loadedData
                    print("Loaded file: \(self.file)")
                }
            }
        }
        catch {
            print("Something went wrong with the request...")
        }
        CSVFile.fileRequest.predicate = tmp
    }
    //deletes every result when searching <name> in the fileRequest
    func clear(name: String) {
        CSVFile.fileRequest.returnsObjectsAsFaults = false
        let tmp = CSVFile.fileRequest.predicate
        do {
            let results = try CSVFile.fileContext.fetch(CSVFile.fileRequest) as? [NSManagedObject]
            if results!.count > 0 {
                //delete all results
                for object in results! {
                    print("Removed \(object)")
                    CSVFile.fileContext.delete(object)
                }
            }
        } catch {
            print("Something went wrong clearing out all the teams from disk")
        }
        CSVFile.fileRequest.predicate = tmp
    }
    
    //clear all files from disk
    static func clearAll() -> Void {
        do {
            let results = try CSVFile.fileContext.fetch(fileRequest) as? [NSManagedObject]
            if results!.count > 0 {
                //delete all results
                for object in results! {
                    print("Removed \(object)")
                    CSVFile.fileContext.delete(object)
                }
            }
        } catch {
            print("Something went wrong clearing out all the files from disk")
        }
    }
    
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
