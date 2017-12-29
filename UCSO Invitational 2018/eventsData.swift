//
//  eventsData.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 12/28/17.
//  Copyright © 2017 bayser. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Events")

class EventsData: NSObject {
    static var list:[String] = []
    static let completeList = ["Anatomy & Physiology", "Astronomy", "Chemistry Lab", "Disease Detectives", "Dynamic Planet", "Ecology", "Experimental Design", "Fermi Questions", "Forensics", "Game On", "Helicopters", "Herpetology", "Hovercraft", "Materials Science", "Microbe Mission", "Mission Possible", "Mousetrap Vehicle", "Optics", "Remote Sensing", "Rocks & Minerals", "Thermodynamics", "Towers", "Write It Do It"]
}

//fetches events from CoreData
func loadEvents() -> Void {
    request.returnsObjectsAsFaults = false
    do {
        let results = try context.fetch(request)
        if results.count > 0 {
            var tmpRes = [String]()
            for result in results {
                if let eventName = (result as AnyObject).value(forKey:"event") as? String {
                    tmpRes.append(eventName)
                }
            }
            EventsData.list = tmpRes
        }
    }
    catch {
        print("Something went wrong with the request...")
    }
}

//Dumps everything to storage
func firstSaveEvents() -> Void {
    for eachEvent in EventsData.list {
        addEvent(eventName: eachEvent)
    }
}

//Save the event list in storage
func saveEvents() -> Void {
    clearEvents() //for convenience
    for eachEvent in EventsData.list {
        addEvent(eventName: eachEvent)
    }
}


//add an event with CoreData
func addEvent(eventName: String) -> Void {
    let newEventThing = NSEntityDescription.insertNewObject(forEntityName: "Events", into: context)
    newEventThing.setValue (eventName, forKey: "event")
    do {
        try context.save()
        print("Saved!")
    }
    catch {
        print("Something went wrong with adding an event")
    }
}

//removes the first occurrence of an event
func removeEvent(eventName: String, indexPath: IndexPath) -> Bool {
    EventsData.list.remove(at: indexPath.row)
    request.predicate = NSPredicate(format: "event = %@", eventName) //??
    var res : Bool = false
    do {
        let results = try context.fetch(request) as? [NSManagedObject]
        if results!.count > 0 {
            let object = results!.first
            //print("Removed \(String(describing: object))")
            context.delete(object!)
            res = true
        }
    } catch {
        print("Something went wrong deleting the event \(eventName)")
    }
    return res
}
//remove all events
func clearEvents() -> Void {
    do {
        let results = try context.fetch(request) as? [NSManagedObject]
        if results!.count > 0 {
            //delete all results
            for object in results! {
                print("Removed \(object)")
                context.delete(object)
            }
        }
    } catch {
        print("Something went wrong clearing out all the events")
    }
}

