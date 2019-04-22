//
//  MapViewController.swift
//  Spot
//
//  Created by Victoria Elaine Maxwell on 2/15/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Geofirestore

class MapViewController: UIViewController {
    
    //Change status bar theme color white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    
    let db: Firestore! = Firestore.firestore()
    let storage = Storage.storage()
    let spotsRef = Firestore.firestore().collection("spots")
    let geoFirestore = GeoFirestore(collectionRef: Firestore.firestore().collection("spots"))
    let id: String = Auth.auth().currentUser?.uid ?? "invalid user"
    
    let rainbowSpot = UIImage(named: "RainbowSpotIcon")
    let blackSpot = UIImage(named: "BlackSpotIcon")
    let greenSpot = UIImage(named: "GreenSpotIcon")
    
    var markers: [String: GMSMarker] = [:]
    
    private var infoWindow = MarkerInfoWindow()
    var locationMarker : GMSMarker? = GMSMarker()
    
    var circleQuery: GFSCircleQuery?
    let locationGroup = DispatchGroup()
    var firstTimeGettingLocation = true
    
    var spotID : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "Signuplogo.png"))
        
        mapView.delegate = self
        locationManager.delegate = self
        
        
        locationGroup.enter()
        startLocationServices()
        
        locationGroup.notify(queue: DispatchQueue.main) {
         
            guard let lat = self.mapView.myLocation?.coordinate.latitude,
                let lng = self.mapView.myLocation?.coordinate.longitude else { return }
            
            self.circleQuery = self.geoFirestore.query(withCenter: GeoPoint(latitude: lat, longitude: lng), radius: 0.804672)
            
            let _ = self.circleQuery?.observe(.documentEntered, with: self.loadSpotFromDB)
 
 
        }
 
    }
    
    
    @IBAction func moveToMyLocation(_ sender: UIButton) {
        
        guard let lat = mapView.myLocation?.coordinate.latitude,
            let lng = mapView.myLocation?.coordinate.longitude else { return }
        
        let myLocation = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mapView.animate(toLocation: myLocation)
    }
    

    @IBAction func addSpot(_ sender: Any) {
        
    }
    
    
    func startLocationServices() {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            
            case .restricted, .denied:
                //Do something if access to location services is denied; notify user that app can't be used without authorization
                break
            
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
                mapView.isMyLocationEnabled = true
                break
            
        }
    }

    
    //getting spot from database
    func loadSpotFromDB(key: String?, location: CLLocation?) {
        //checking to make sure marker isn't already displaying
        if let spotKey = key, markers[key!] == nil {
            let group = DispatchGroup()
            
            //getting spot document from database so marker can be made
            self.spotsRef.document(spotKey).getDocument { (document, error) in
                if let document = document, document.exists {
                    let description = document.get("description")
                    let lat = location?.coordinate.latitude as! Double
                    let long = location?.coordinate.longitude as! Double
                    let privacyLevel = document.get("privacyLevel") as? String
                    let spotName = document.get("spot name")
                    
                    var image = UIImage(named: "Signuplogo")
                    
                    if let imageURL = document.get("image url") as? String {
                        let gsRef = Storage.storage().reference(forURL: imageURL)
                        
                        group.enter()
                        gsRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if (error != nil) {
                                print("error occured in getting image from storage")
                            } else {
                                image = UIImage(data: data!)
                            }
                            group.leave()
                        }
                        
                    }
                    
                    group.notify(queue: DispatchQueue.main) {
                        let spotData = ["spotId": spotKey, "description": description, "latitude": lat, "longitude": long, "privacyLevel": privacyLevel, "spotName": spotName, "image": image]
                        
                        self.loadSpotToMap(data: spotData)
                    }
 
                } else {
                    print("Document does not exist")
                }
            }
                
        }
    }
    
    
    //making marker to add to map
    func loadSpotToMap(data: [String:Any]) {
        let spotID = data["spotId"] as! String
        let privacyLevel = data["privacyLevel"] as? String
        guard let lat = data["latitude"] as? Double else {
            return
        }
        guard let long = data["longitude"] as? Double else {
            return
        }
        
        let markerPos = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let marker = GMSMarker(position: markerPos)
        
        if (privacyLevel == "private") {
            marker.icon = self.blackSpot
        } else if (privacyLevel == "friends") {
            marker.icon = self.greenSpot
        } else {
            marker.icon = self.rainbowSpot
        }
        
        marker.isFlat = true
        marker.map = self.mapView
        marker.userData = data
        self.markers[spotID] = marker
    }
    
    //making instance of view for info window
    func loadNiB() -> MarkerInfoWindow {
        let infoWindow = MarkerInfoWindow.instanceFromNib() as! MarkerInfoWindow
        return infoWindow
    }

}

//delegate to handle location related events
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse, status == .authorizedAlways else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        if (firstTimeGettingLocation) {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 18, bearing: 0, viewingAngle: 65)
            mapView.isBuildingsEnabled = true
            firstTimeGettingLocation = false
            locationGroup.leave()
        } else {
            mapView.animate(toLocation: location.coordinate)
            
        }
        
        locationManager.pausesLocationUpdatesAutomatically = true
        //locationManager.stopUpdatingLocation()
    }
    
}

//delegate to handle events from the map
extension MapViewController: GMSMapViewDelegate {
    
    //creating info window for marker
     func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        var markerData: Dictionary<String, Any>?
        if let data = marker.userData! as? Dictionary<String, Any> {
            markerData = data
        }

        infoWindow = loadNiB()
        infoWindow.spotData = markerData
     
        let description = markerData!["description"] as? String
        let title = markerData!["spotName"] as? String
        let image = markerData!["image"] as? UIImage
        
        infoWindow.titleLabel.text = title
        infoWindow.descriptionLabel.text = description
        infoWindow.spotImage.image = image
     
        return infoWindow
     }
    
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("did tap marker")
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("tapped on map")
    }
    
    //updating circle query when camera position changes
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        let lat = cameraPosition.target.latitude
        let long = cameraPosition.target.longitude
        
        circleQuery?.center = CLLocation(latitude: lat, longitude: long)
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker){
        self.spotID = infoWindow.spotData!["spotId"] as! String
        
        self.performSegue(withIdentifier: "mapToSpotPage", sender: self )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.spotID)
        if segue.identifier == "mapToSpotPage"{
            //if let destination = segue.destination as? UITabBarController,
            if let navController = segue.destination as? UINavigationController,
                let homeController = navController.topViewController as? SpotViewController{
                homeController.spotId = self.spotID
            }
        }
    }

}
