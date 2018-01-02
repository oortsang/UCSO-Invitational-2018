//
//  ScheduleData.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 12/29/17.
//  Copyright © 2017 bayser. All rights reserved.
//

import Foundation

class EventLabel {
    var name = ""
    var loc = ""
    var time = ""
    func getTime() -> String! {
        return self.time
    }
    func getTuple() -> (String, String, String) {
        return (self.name, self.loc, self.time)
    }
    func setTuple(setName: String, setLoc: String, setTime: String) {
         (self.name, self.loc, self.time) = (setName, setLoc, setTime)
    }
    //returns a string
    func print() -> String! {
        return "\(self.time) @ \(self.loc): \(self.name)"
    }
    
    init(name: String, loc: String, time: String) {
        (self.name, self.loc, self.time) = (name, loc, time)
    }
}


//returns a list of events in chronological/alphabetical order
func orderEvents(eventList: [EventLabel]) -> [EventLabel] {
    return eventList.sorted(by: comesBefore)
}

//returns whether first event happens before the second event
func comesBefore (ev1: EventLabel, ev2: EventLabel) -> Bool {
    var isBefore = true
    let hourOrder = [7,8,9,10,11,12,1,2,3,4,5,6]
    let separator = {(str: String) -> [String] in return str.components(separatedBy: ":")}
    let hourIndex = {(i: Int) -> Int? in return hourOrder.index(of: i)}
    let (t1, t2) =  (ev1.getTime(), ev2.getTime())
    let (s1, s2) = (separator(t1!), separator(t2!))
    let (h1, h2) = (Int(s1[0])!, Int(s2[0])!)
    let (m1, m2) = (s1[1].first!, s2[1].first!)

    isBefore = hourIndex(h1)! < hourIndex(h2)!
    if (hourIndex(h1)! == hourIndex(h2)!) {
        isBefore = m1 < m2
        if m1 == m2 {
            isBefore = ev1.name < ev2.name
        }
    }
    return isBefore
}



//temporary info; hopefully can change later
class ScheduleData {
    static var events : [EventLabel] = []
    static var homeroomList:[String] = [] //store all the homerooms, 0-indexed
    static var homeroom = "" //change depending on school
    static var earlyEvents = [
        EventLabel(name: "Coach's Meeting/Check-in", loc: "Reynold's Club", time: "7:30-8:00 AM"),
        EventLabel(name: "Impound (if applicable)", loc: "build event locations", time: "8:00-8:30 AM")
    ]
    static var lateEvents = [
        EventLabel(name: "Fun Activities (Tour, Student Panel, etc.)", loc: "Reynolds Club and Mandel", time: "2:30-3:30 PM"),
        EventLabel(name: "Student Organization Performances", loc: "Mandel", time: "3:30-4:15 PM"),
        EventLabel(name: "Keynote Speech by Jenny Kopach", loc: "Mandel", time: "4:15-4:30 PM"),
        EventLabel(name: "Awards Ceremony", loc: "Mandel", time: "4:30-6:00 PM")
    ]
    static func eventTime (teamName: String) -> String! {
        return "12:00 PM" //CHANGE THIS
    }
    static func eventLoc (teamName: String) -> String! {
        return "(location of event)" //ALSO CHANGE THIS
    }
}
