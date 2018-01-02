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
    @IBOutlet weak var schedView: UITableView!
    
    //var homeroomFile = CSVFile()
    var dlFiles = Downloadable()
    
    override func viewDidLoad() {
        loadSchoolName()
        loadEvents()
        super.viewDidLoad()
        //load homeroom info
        /*homeroomFile.load(fileName: "homerooms") //what happens if it's not there to begin with?
        print(homeroomFile.file)
        homeroomFile.downloadFile(sourceURL: CSVFile.homeroomAddress)
        homeroomFile.save(name: "homerooms")
        */
        
        updateSchoolAndTable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSchoolAndTable), name: .reloadSchoolName, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(updateSchoolAndTable), name: .reload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDownloadSummoned), name: .downloadFinished, object: nil)
        
        //extra detail by tapping on a cell
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        recognizer.delegate = self as? UIGestureRecognizerDelegate
        schedView.addGestureRecognizer(recognizer)
    }
    
    //handle taps on the UITableView
    @objc func onTap(recognizer : UITapGestureRecognizer) {
        //if recognizer.state == .began {
        if recognizer.state == .ended {
            let touchPoint = recognizer.location(in: schedView)
            if let indexPath = schedView.indexPathForRow(at: touchPoint) {
                let cell = schedView.cellForRow(at: indexPath)
                print(indexPath)
                //modify when cells get prettier!
                let msg = cell?.textLabel!.text
                let alert = UIAlertController(title: "Event", message: msg,  preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(title:
                        NSLocalizedString("Ok", comment: "Default action"),
                                  style: .default)
                )
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //on download finish
    @objc func onDownloadSummoned () {
        dlFiles.finishUpdate()
    }
    
    //update the text to reflect current team set
    @objc func updateSchoolAndTable() {
        //update team info
        let sName = EventsData.currentSchool
        let sNumber = EventsData.teamNumber()!
        if dlFiles.homerooms.data.count > 1 {
            ScheduleData.updateHomerooms(dataFile: dlFiles.homerooms)
        }
        schoolTitle.text = "Viewing as: (\(sNumber)) \(sName)"
        homeroomLocation.text = "Homeroom: \(ScheduleData.homeroom)"
        saveSchoolName(teamName: sName)
        
        //update the table itself
        self.updateEvents()
        
        schedView.reloadSections(IndexSet(integer: 1), with: .none)
        //schedView.reloadData()
        schedView.reloadInputViews()
    }

    
    //put the events back into ScheduleData.events so that it can be nicely formatted
    func updateEvents() {
        var elList: [EventLabel] = []
        print(dlFiles.testEvents.data)
        for (i, elm) in EventsData.list.enumerated() {
            let name = elm
            let loc = dlFiles.testEvents.data[i+1][5]
            let teamBlock =  Int(ceil(Float(EventsData.teamNumber()!/10))) //1-10,11-20,21-30,31-40
            print(EventsData.teamNumber()!, i, teamBlock)
            let time = dlFiles.testEvents.data[i+1][teamBlock]  + ":00"
            let tmp = EventLabel(name: name, loc: loc, time: time)
            elList.append(tmp)
        }
        print("Reloading...\n\n")
        ScheduleData.events = elList
        //schedView.reloadInputViews()
    }
    
    //MARK: mostly boring table management stuff below this point
    
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
        case 2:
            return ScheduleData.lateEvents.count
        default:
            return EventsData.list.count //the meat and potatoes
        }
    }
    
    //give labels to the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Getting Knowledge from section \(indexPath.section), I see...")
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedule", for: indexPath)
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
        case 2:
            cell.textLabel!.text = (ScheduleData.lateEvents[indexPath.row] as EventLabel).print()
            break
        default:
            let strings = ScheduleData.events.map {$0.print() + ", "}
            print ("[", strings, "]", indexPath.row)
            //fix when we get more data from online
            //cell.textLabel!.text = (ScheduleData.events[indexPath.row] as EventLabel).print()
        }
        return cell
    }
}
