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
    
    // Get the refresh button to refresh
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        dlFiles.beginUpdate()
        NotificationCenter.default.post(name: .reloadSchoolName, object:nil)
    }

    //called every time the view is brought to view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dlFiles.beginUpdate() // call the update now
    }

    //called just at the beginning of the app
    override func viewDidLoad() {
        loadSchoolName()
        loadEvents()
        updateEvents()
        
        super.viewDidLoad()
	updateSchoolAndTable()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateSchoolAndTable), name: .reloadSchoolName, object: nil)
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
                let title = cell?.textLabel!.text
                let msg = cell?.detailTextLabel!.text
                let alert = UIAlertController(title: title, message: msg,  preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(title:
                        NSLocalizedString("Ok", comment: "Default action"),
                                  style: .default)
                )
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //on download finish (note: does not update view)
    @objc func onDownloadSummoned () {
        //print("Download summoned")
        dlFiles.finishUpdate()
        updateSchoolAndTable()
        //print("Finished onDownloadSummoned")
    }
    
    //update the text to reflect current team set
    @objc func updateSchoolAndTable() {
        DispatchQueue.main.async() {
            //update team info
            let sName = EventsData.currentSchool
            let sNumber = EventsData.teamNumber()!
            if self.dlFiles.homerooms.data.count > 1 {
                ScheduleData.updateHomerooms(dataFile: self.dlFiles.homerooms)
            }
            self.schoolTitle.text = "Viewing as: (\(sNumber)) \(sName)"
            self.homeroomLocation.text = "Homeroom: \(ScheduleData.homeroom)"
            saveSchoolName(teamName: sName)
            
            //update the table itself
            self.updateEvents()
            
            //schedView.reloadSections(IndexSet(integer: 1), with: .none)
            self.schedView.reloadSections(IndexSet([0,1,2]) , with: .none)
            //schedView.reloadData()
            self.schedView.reloadInputViews()
        }
    }
    
    //helper function just for string processing
    func cleanTime(time: String, duration: Int = 50) -> String! {
        var result = time
        if time == "" || time == "?" {
            result = "?"
        } else if time.count <= 2 {
            if duration < 60 && duration != 0 {
                let strDur = String(duration)
                let end = time + ":" + ((strDur.count < 2) ? ("0"+strDur) : (strDur))
                let ampm = (Int(time)! > 5) ? "A" : "P"
                result += ":00 - \(end) \(ampm)M"
            } else {
                let ampm = (Int(time)! > 5) ? "A" : "P"
                result += ":00 \(ampm)M"
            }
        } //leave the time alone if it is a 'full' time, i.e. 8:00-8:30 or 9:00
        return result
    }
    //put the events back into ScheduleData.events so that it can be nicely formatted
    func updateEvents() {
        var elList: [EventLabel] = []
        if dlFiles.testEvents.file == "" {return}
        for elm in EventsData.list {
            let i = EventsData.completeList.index(of: elm)!
            
            // make sure no index-out-of-bounds error for `loc`
            if dlFiles.testEvents.data.count <= i+1 {
                return
            } else if dlFiles.testEvents.data[i+1].count <= 5 {
                return
            }
            let loc = dlFiles.testEvents.data[i+1][5]


            var time = "?"
            
            //check for build events
            if (EventsData.isSelfScheduled(evnt: elm)) {
                //lookup from build event file
                let teamNumber = EventsData.teamNumber()!
                let j = 1+EventsData.selfScheduled.index(of: elm)!
                //print("Trying to access: team number \(teamNumber) for the \(j)th event")
                time = cleanTime(time: dlFiles.buildEvents.data[j][teamNumber])
            } else {
                let teamBlock =  Int(ceil(Float(EventsData.teamNumber()!)/10)) //1-10,11-20,21-30,31-40
                time = cleanTime(time: dlFiles.testEvents.data[i+1][teamBlock])
            }
            //print(time)
            let tmp = EventLabel(name: elm, loc: loc, time: time)
            elList.append(tmp)
        }
        ScheduleData.events = orderEvents(eventList: elList)
        
        //print("At the end of updateEvents, there are \(ScheduleData.events.count) events")
    }
    
    //MARK: mostly boring table management stuff below this point
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ScheduleData.earlyEvents.count + EventsData.impoundList().count
        case 2:
            return ScheduleData.lateEvents.count
        default:
            return EventsData.list.count //the meat and potatoes
        }
    }
    
    //give labels to the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("Getting Knowledge from section \(indexPath.section), I see...")
        var cell = tableView.dequeueReusableCell(withIdentifier: "schedule", for: indexPath)
        let section = indexPath.section
        switch section {
        case 0:
            //print(indexPath.row)
            if indexPath.row < ScheduleData.earlyEvents.count {
                //cell.textLabel!.text = (ScheduleData.earlyEvents[indexPath.row] as EventLabel).print()
                cell = (ScheduleData.earlyEvents[indexPath.row] as EventLabel).printCell(cell: cell)
            } else {
                let beName = EventsData.impoundList()[indexPath.row - ScheduleData.earlyEvents.count]
                let i = EventsData.completeList.index(of: beName)!
                let teamBlock = Int(ceil(Float(EventsData.teamNumber()!)/10))
                var loc = ""
                var time = ""
                //if beName == "Hovercraft" {
                    // make sure no index-out-of-bounds error for `cleanTime`
                    if dlFiles.testEvents.data.count <= i+1 || dlFiles.testEvents.data[i+1].count <= teamBlock {
                        time = "8:00 - 8:30 AM"
                    } else {
                        time = cleanTime(time: dlFiles.testEvents.data[i+1][teamBlock],
                                         duration: 30)!
                        loc = dlFiles.testEvents.data[i+1][5]
                    }
//                } else {
//                    time = "8:00 - 8:30 AM"
//                }
                var evName = "Impound for " + beName
                if beName == "Hovercraft" {
                    evName = "Written Test + " + evName
                }
                let buildEvent = EventLabel(name: evName, loc: loc, time: time)
                
                cell  = buildEvent.printCell(cell: cell)
            }
            break
        case 2:
            cell = (ScheduleData.lateEvents[indexPath.row] as EventLabel).printCell(cell: cell)
            break
        default:
            // check that ScheduleData.events is not empty
            if ScheduleData.events.count == 0 {
                cell.textLabel!.text = "???"
                cell.detailTextLabel!.text = "pls connect to the internet :|"
            }
            // check that we actually have a testEvents file
            else if dlFiles.testEvents.file == "" || dlFiles.buildEvents.file == "" {
                cell.textLabel!.text = (ScheduleData.events[indexPath.row] as EventLabel).name
                cell.detailTextLabel!.text = "Entry not found: Please connect to internet"
            } else {
                cell = (ScheduleData.events[indexPath.row] as EventLabel).printCell(cell: cell)
            }
        }
        return cell
    }
}
