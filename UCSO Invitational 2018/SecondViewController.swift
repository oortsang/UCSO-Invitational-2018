//
//  SecondViewController.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 12/10/17.
//  Copyright © 2017 bayser. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var schoolTitle: UITextField!
    @IBOutlet weak var homeroomLocation: UITextField!
    
    var homeroomFile = CSVFile()
    
    override func viewDidLoad() {
        loadEvents()
        super.viewDidLoad()
        //load homeroom info
        homeroomFile.load(fileName: "homerooms") //what happens if it's not there to begin with?
        print(homeroomFile.file)
        //homeroomFile.downloadFile(sourceURL: CSVFile.homeroomAddress)
        homeroomFile.save(name: "homerooms")
        
        loadSchoolTitleText()
         NotificationCenter.default.addObserver(self, selector: #selector(updateSchoolTitleText), name: .reloadSchoolName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDownloadSummoned), name: .downloadFinished, object: nil)
        //allow detail by tapping on a cell
        /*let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        recognizer.delegate = self as? UIGestureRecognizerDelegate
        tableView.addGestureRecognizer(recognizer)*/
    }
    /*
    @objc func onTap(recognizer : UITapGestureRecognizer) {
        if recognizer.state == .began {
            let touchPoint = recognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "schedule", for: indexPath)
                let alert = UIAlertController(title: "Event", message: cell.textLabel!.text,  preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(title:
                        NSLocalizedString("Ok", comment: "Default action"),
                                  style: .default)
                )
            }
        }
    }*/
    
    @objc func onDownloadSummoned () {
        //for homeroom stuff
        ScheduleData.updateHomerooms(dataFile: homeroomFile)
    }
    //update load team name from file
    @objc func loadSchoolTitleText() {
        loadSchoolName()
        updateSchoolTitleText()
        updateTable()
    }
    
    @objc func updateTable() -> Void {
        //
    }
    
    //update the text to reflect current team set
    @objc func updateSchoolTitleText() {
        let sName = EventsData.currentSchool
        let sNumber = EventsData.teamNumber()!
        if homeroomFile.data.count > 1 {
            ScheduleData.updateHomerooms(dataFile: homeroomFile)
        }
        schoolTitle.text = "Viewing as: (\(sNumber)) \(sName)"
        homeroomLocation.text = "Homeroom: \(ScheduleData.homeroom)"
        saveSchoolName(teamName: sName)
    }

    /*
     //put the interesting stuff into the table
    @objc func updateTableContents() {
        schedView.reloadData()
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if hasHovercraft() {
                return 1 + ScheduleData.earlyEvents.count
            } else {
                return ScheduleData.earlyEvents.count
            }
        case 1:
            return ScheduleData.lateEvents.count
        default:
            return EventsData.list.count
        }
    }
    
    //give labels to the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Getting Knowledge, I see...")
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedule", for: indexPath)
        //cell.textLabel!.text = EventsData.list[indexPath.row]
        let section = indexPath.section
        switch section {
        case 0:
            print(indexPath.row)
            if hasHovercraft() && (indexPath.row == ScheduleData.earlyEvents.count) {
                let hoverWrite = EventLabel(name: "Hovercraft Impound/Written Test", loc: "(?)", time: "8:00-8:30 AM")
                cell.textLabel!.text = hoverWrite.print()
            } else {
                cell.textLabel!.text = (ScheduleData.earlyEvents[indexPath.row] as EventLabel).print()
            }
            break
        case 1:
            cell.textLabel!.text = (ScheduleData.lateEvents[indexPath.row] as EventLabel).print()
            break
        default:
            print (ScheduleData.events, indexPath.row)
            //fix when we get more data from online
            //cell.textLabel!.text = (ScheduleData.events[indexPath.row] as EventLabel).print()
        }
        return cell
    }
}
