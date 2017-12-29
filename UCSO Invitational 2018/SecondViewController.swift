//
//  SecondViewController.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 12/10/17.
//  Copyright © 2017 bayser. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    @IBOutlet weak var schoolTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSchoolTitleText()
         NotificationCenter.default.addObserver(self, selector: #selector(updateSchoolTitleText), name: .reloadSchoolName, object: nil)
    }
    //update load team name from file
    @objc func loadSchoolTitleText() {
        loadSchoolName()
        updateSchoolTitleText()
    }
    
    //update the text to reflect current team set
    @objc func updateSchoolTitleText() {
        let sName = EventsData.currentSchool
        let sNumber = 1 + EventsData.roster.index(of: sName)!
        schoolTitle.text = "Viewing as: (\(sNumber)) \(sName)"
        saveSchoolName(teamName: sName)
        print(sName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
