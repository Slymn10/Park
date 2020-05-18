//
//  Park.swift
//  Park
//
//  Created by Süleyman Koçak on 18.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import Foundation
import CoreLocation
struct Park {
    let uid : String
    var location:CLLocation?
    init(uid:String) {
        self.uid = uid
    }
}
