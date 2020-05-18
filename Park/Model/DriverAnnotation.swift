//
//  DriverAnnotation.swift
//  Park
//
//  Created by Süleyman Koçak on 17.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import MapKit

class ParkAnnotation:NSObject,MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var uid: String

    init(uid:String,coordinate:CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }

    func updateAnnotationPosition(coordinate:CLLocationCoordinate2D){
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }



}
