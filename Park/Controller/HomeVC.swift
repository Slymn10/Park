//
//  ViewController.swift
//  Park
//
//  Created by Süleyman Koçak on 17.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import Firebase
import GeoFire
import MapKit
import UIKit

private let annotationIdentifier = "ParkAnno"
class HomeVC: UIViewController{

   //MARK: - Properties

   //Back button for removing polylines
   private let actionButton: UIButton = {
      let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-2").withTintColor(.systemPink, renderingMode: .alwaysOriginal), for: .normal)
      button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
      return button
   }()
   private var location = LocationHandler.shared.locationManager.location
   private let mapView = MKMapView()
   private var route: MKRoute?
   private let locationManager = LocationHandler.shared.locationManager

   //MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      enableLocationServices()
      configureMapView()
      fetchParks()
      //Alpha is zero at first.Because in the beginning there is no polyline.
      actionButton.alpha = 0
    view.addSubview(actionButton)
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        actionButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
        actionButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
        actionButton.heightAnchor.constraint(equalToConstant: 30),
        actionButton.widthAnchor.constraint(equalToConstant: 30)
    ])

   }

   //MARK: - Helper Functions
   func configureMapView() {
      view.addSubview(mapView)
      mapView.frame = view.frame
      mapView.delegate = self
      mapView.showsUserLocation = true
      mapView.userTrackingMode = .follow
   }
    //Fetches park location and shows them on the mapView.
   func fetchParks() {
      guard let location = locationManager?.location else { return }
      Service.shared.fetchParks(location: location) { (park) in

         guard let coordinate = park.location?.coordinate else { return }
         let annotation = ParkAnnotation(uid: park.uid, coordinate: coordinate)
         var driverIsVisible: Bool {
            return self.mapView.annotations.contains { annotation -> Bool in
               guard let parkAnno = annotation as? ParkAnnotation else { return false }
               if parkAnno.uid == park.uid {
                  //update position
                  parkAnno.updateAnnotationPosition(coordinate: coordinate)
                  return true
               }
               return false
            }


         }
         if !driverIsVisible {
            self.mapView.addAnnotation(annotation)
         }

      }
   }
    //Removes polylines from the mapView
   func removeAnnotationsAndOverlays() {
      self.mapView.annotations.forEach { (annotation) in
         if let anno = annotation as? MKPointAnnotation {
            self.mapView.removeAnnotation(anno)
         }
      }
      if mapView.overlays.count > 0 {
         self.mapView.removeOverlay(self.mapView.overlays[0])
      }
   }

   //MARK: - Selectors

    //When actionButton pressed, polylines on the map will be removed.
   @objc func actionButtonPressed() {
    self.actionButton.alpha = 0
      self.removeAnnotationsAndOverlays()
   }


}
//MARK: - MKMapViewDelegate
extension HomeVC: MKMapViewDelegate{
    //Trigger generatePolyline function which creates polylines
   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if self.actionButton.alpha == 0{
        self.actionButton.alpha = 1
    }else if self.actionButton.alpha == 1 {
        self.actionButton.alpha = 0
    }
      let destination = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))
      self.generatePolyline(toDestination: destination)
   }

    //Adding annotations for available park location
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      if let annotation = annotation as? ParkAnnotation {
         let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
         view.image = #imageLiteral(resourceName: "icons8-parking-25")
         return view
      }
      return nil
   }

    //Polyline style
   func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let route = self.route {
         let polyline = route.polyline
         let lineRenderer = MKPolylineRenderer(polyline: polyline)
         lineRenderer.strokeColor = .systemPink
         lineRenderer.lineWidth = 4
         return lineRenderer
      }
      return MKOverlayRenderer()
   }

    //This generates polylines from source(current location) to destination.
   func generatePolyline(toDestination destination: MKMapItem) {
      let request = MKDirections.Request()
      request.source = MKMapItem.forCurrentLocation()
      request.destination = destination
      request.transportType = .automobile
      let directionRequest = MKDirections(request: request)

      directionRequest.calculate { (response, error) in
         guard let response = response else { return }
         self.route = response.routes[0]
         guard let polyline = self.route?.polyline else { return }
         self.mapView.addOverlay(polyline)
      }
   }

    //This puts dummy data to firebase.That was a one time thing.
   func putLocations() {
      let uid = UUID().uuidString
      guard let location = self.location else { return }
      let geofire = GeoFire(firebaseRef: REF_PARK_LOCATIONS)
      let values: [String: Any] = ["isAvailable": true]
      geofire.setLocation(location, forKey: uid) { (error) in
         self.uploadParkData(uid: uid, values: values)
      }
   }
   func uploadParkData(uid: String, values: [String: Any]) {
      REF_PARK.child(uid).updateChildValues(values) { (error, ref) in
         if error != nil {
            print(error!.localizedDescription)
            return
         }
      }
   }
}

//MARK: - Location Services
extension HomeVC {
    //This requires permission for user location.
   func enableLocationServices() {
      switch CLLocationManager.authorizationStatus() {
      case .notDetermined:
         locationManager?.requestWhenInUseAuthorization()
      case .restricted, .denied:
         break
      case .authorizedAlways:
         locationManager?.startUpdatingLocation()
         locationManager?.desiredAccuracy = kCLLocationAccuracyBest
      case .authorizedWhenInUse:
         locationManager?.requestAlwaysAuthorization()
      @unknown default:
         break
      }
   }



}
