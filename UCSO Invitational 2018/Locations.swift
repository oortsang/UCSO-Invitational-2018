//
//  Locations.swift
//  mapdemo
//
//  Created by Jung-Sun Yi-Tsang on 12/9/17.
//  Copyright © 2017 bayser. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


let locList: [(String, String, Double, Double)]
    = [ ("BSLC", "Biological Sciences Learning Center", 41.7914471, -87.6026488),
        ("Hinds", "Hinds Geophysical Sciences Center", 41.7902933, -87.6016511),
        ("Crerar+CSIL", "Crerar Library (contains Computer Science Instructional Laboratory)", 41.790225, -87.602556),
        ("Harper", "Harper Memorial Library", 41.7879593, -87.5995794),
        ("Lab Schools", "UC Lab Schools", 41.7880278, -87.5939404),
        ("Mandel/Reynolds", "Mandel Hall / Reynolds Club", 41.791237, -87.5982604),
        ("KPTC", "Kersten Physics Teaching Center", 41.7910491, -87.6014493),
        ("GCIS", "Gorden Center for Integrative Sciences / James Franck Institute", 41.7911308,-87.6027497)
    ]

struct MyList {
    static var locPoints = [MKPointAnnotation]()
    
    static func initiate() -> Void {
        for elm in locList{
            let an = MKPointAnnotation()
            an.title = elm.0
            an.subtitle = elm.1
            an.coordinate = CLLocationCoordinate2DMake(elm.2, elm.3)
            locPoints.append(an)
        }
    }
}

    
