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
    var downloadInProgress = false
    
    //start the downloads
    func beginUpdate() {
    	//don't start if a download is already in progress
    	if downloadInProgress{
	    print("Download already in progress!")
	    return
	}
        self.homerooms.downloadFile(sourceURL: CSVFile.homeroomAddress)
        self.testEvents.downloadFile(sourceURL: CSVFile.testEventAddress)
        self.buildEvents.downloadFile(sourceURL: CSVFile.buildEventAddress)
	downloadInProgress = true
    }
    
    //save and parse
    func finishUpdate() {
        self.save()
        self.parse()
	downloadInProgress = false
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
        self.load()
        self.beginUpdate()
    }
}
