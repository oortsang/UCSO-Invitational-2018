//
//  Downloadables.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 1/2/18.
//  Copyright © 2018 bayser. All rights reserved.
//

import Foundation

class Downloadable {
    let homerooms = CSVFile()
    let testEvents = CSVFile()
    let buildEvents = CSVFile()
    //let funEvents = CSVFile()
    
    //start the downloads
    func beginUpdate() {
        self.homerooms.downloadFile(sourceURL: CSVFile.homeroomAddress)
        self.testEvents.downloadFile(sourceURL: CSVFile.testEventAddress)
        self.buildEvents.downloadFile(sourceURL: CSVFile.buildEventAddress)

    }
    
    //save and parse
    func finishUpdate() {
        self.save()
        self.parse()
    }
    
    func save() {
        self.homerooms.save(name: "homerooms")
        self.testEvents.save(name: "testevents")
        self.buildEvents.save(name: "buildevents")
    }
    
    func parse() {
        self.homerooms.parse()
        self.testEvents.parse()
        self.testEvents.parse()
    }
    func load() {
        self.homerooms.load(fileName: "homerooms")
        self.testEvents.load(fileName: "testevents")
        self.buildEvents.load(fileName: "buildevents")
    }
    
    //initialize the files
    init() {
        //what happens if it's not there to begin with?
        self.load()
        self.beginUpdate()
    }
}
