//
//  ModalSchoolPicker.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 12/28/17.
//  Copyright © 2017 bayser. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let reloadSchoolName = Notification.Name("reloadSchool")
}

class ModalSchoolPicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var schoolPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolPicker.dataSource = self
        schoolPicker.delegate = self
        //set default value, but beware that this is zero-indexed
        let sNumber0 = EventsData.roster.index(of: EventsData.currentSchool)!
        schoolPicker.selectRow(sNumber0, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in eventPicker: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return EventsData.roster.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String("(\(row+1)) \(EventsData.roster[row])")
    }
    
    @IBAction func doneButton(_ sender: Any) {
        let row = schoolPicker.selectedRow(inComponent: 0)
        EventsData.currentSchool = EventsData.roster[row]
        //figure out core data business later...
        
        sendSchoolNotificationToUpdate()
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendSchoolNotificationToUpdate() -> Void {
        NotificationCenter.default.post(name: .reloadSchoolName, object: nil)
    }
    
}

