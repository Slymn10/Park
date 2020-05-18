//
//  Service.swift
//  Park
//
//  Created by Süleyman Koçak on 17.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//
import CoreLocation
import Firebase
import GeoFire

let DB_REF = Database.database().reference()
let REF_PARK = DB_REF.child("parks")
let REF_PARK_LOCATIONS = DB_REF.child("park-locations")

class Service {
   static let shared = Service()

   func fetchParks(location: CLLocation, completion: @escaping (Park) -> Void) {
      let geofire = GeoFire(firebaseRef: REF_PARK_LOCATIONS)
      REF_PARK_LOCATIONS.observe(.value) { (snapshot) in
         geofire.query(at: location, withRadius: 50).observe(
            .keyEntered,
            with: { (uid, location) in
               self.fetchParkData(uid: uid) { park in
                  var driver = park
                  driver.location = location
                  completion(driver)
               }
            })
      }
   }
   func fetchParkData(uid: String, completion: @escaping (Park) -> Void) {
      REF_PARK.child(uid).observe(.value) { (snapshot) in
         guard let dictionary = snapshot.value as? [String: Any] else { return }
         let uid = snapshot.key
         let park = Park(uid: uid)
         guard let isAvailable = dictionary["isAvailable"] as? Bool else { return }
         if isAvailable == true {
            completion(park)
         }

      }
   }


}
