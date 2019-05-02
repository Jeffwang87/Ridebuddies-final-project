//
//  NewRideViewController.swift
//  UberShare
//
//  Created by wxt on 4/20/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import Contacts

class NewRideViewController: UIViewController {

    
    @IBOutlet weak var NameLabel: UITextField!
    @IBOutlet weak var OriginLabel: UITextField!
    @IBOutlet weak var DestinationLabel: UITextField!
    @IBOutlet weak var PeopleLabel: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var PhoneLabel: UITextField!
    
    @IBOutlet weak var cancelbutton: UIBarButtonItem!
    
    @IBOutlet weak var PhotoButton: UIButton!
    @IBOutlet weak var savebutton: UIBarButtonItem!
    @IBOutlet weak var TimeLabel: UIDatePicker!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var ride: Ride!
    var photos: Photos!
//    let regionDistance: CLLocationDistance!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    var didClickOrigin = true
    var imagePicker = UIImagePickerController()
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "cars.png")!)
        PhotoButton.isHidden = true
        imagePicker.delegate = self
        if ride == nil{
            ride = Ride()
        }
//        collectionView.delegate = self
//        collectionView.dataSource = self
        photos = Photos()
        updateUserInterface()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        let regionDistance = 10000 + ride.destinationlocation.distance(from: ride.originlocation)
        let region = MKCoordinateRegion(center: ride.origincoordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
        updateMap()
    }
    func updateUserInterface(){
        OriginLabel.text = ride.originname
        DestinationLabel.text = ride.destinationname
//        updateMap()
    }
    
    func updateMap(){
        mapView.removeAnnotations(mapView.annotations)
        let rideorigin = Rideorigin(locationname: ride.originname, coordinate: ride.origincoordinate)
        let ridedestination = Ridedestination(locationname: ride.destinationname, coordinate: ride.destinationcoordinate)
        mapView.addAnnotation(rideorigin)
        mapView.addAnnotation(ridedestination)
        mapView.setCenter(ride.origincoordinate, animated: true)
    }
    
    func cameraOrlibraryAlert(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ _ in
            self.accessCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.accessLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveCancelAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "save", style: .default) { (_) in
            self.ride.saveData {success in
                self.savebutton.title = "Done"
                self.cancelbutton.title = ""
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }


    @IBAction func CancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
  
    @IBAction func NameFieldReturn(_ sender: UITextField) {
        ride.name = NameLabel.text!
     NameLabel.resignFirstResponder()
    }
    
    
    @IBAction func PeopleFieldReturn(_ sender: UITextField) {
        ride.people = PeopleLabel.text!
    PeopleLabel.resignFirstResponder()
    }
    
    @IBAction func photobuttonpressed(_ sender: UIButton) {
        if ride.documentID == ""{
            saveCancelAlert(title: "This Venue Has Not Benn Saved", message: "You must save this venue")
        } else{
            cameraOrlibraryAlert()
        }
    }

    
  
    @IBAction func PhoneFieldReturn(_ sender: UITextField) {
        ride.phone = PhoneLabel.text!
    PhoneLabel.resignFirstResponder()
    }
    
    @IBAction func OriginbuttonPressed(_ sender: UIButton) {
        didClickOrigin = true
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: { () in
            self.ride.originname = self.ride.name
            self.ride.origincoordinate = self.ride.coordinate})
    }
    
    
    
    @IBAction func DestinationButtonPressed(_ sender: UIButton) {
        didClickOrigin = false
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: { () in
            self.ride.destinationname = self.ride.name
            self.ride.destinationcoordinate = self.ride.coordinate})
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIBarButtonItem) {
        ride.name = NameLabel.text!
        ride.people = PeopleLabel.text!
        ride.phone = PhoneLabel.text!
        ride.Time = TimeLabel.date
        ride.saveData { success in
            if success {
                self.leaveViewController()
            }else {
                print("Error")
            }
            
        }
    }
    
}
extension NewRideViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        ride.placename = place.name!
        ride.coordinate = place.coordinate
        if didClickOrigin {
            ride.originname = ride.placename
            ride.origincoordinate = ride.coordinate
            
        } else {
            ride.destinationname = ride.placename
            ride.destinationcoordinate = ride.coordinate
        }
        dismiss(animated: true, completion: nil)
        updateUserInterface()
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension NewRideViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! RidePhotosCollectionViewCell 
        cell.photo = photos.photoArray[0]
        return cell
    }
}
extension NewRideViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = Photo()
        photo.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        photos.photoArray.append(photo)
        dismiss(animated: true) {
            photo.saveData(ride: self.ride) {(success) in
                self.photos.photoArray.append(photo)
                self.collectionView.reloadData()
        }
            
    }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func accessLibrary() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated:  true, completion: nil)
    }
    func accessCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
}
