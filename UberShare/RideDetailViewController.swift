//
//  RideDetailViewController.swift
//  UberShare
//
//  Created by wxt on 4/20/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import MapKit
import Contacts

class RideDetailViewController: UIViewController {
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var OriginLabel: UILabel!
    @IBOutlet weak var DestinationLabel: UILabel!
    @IBOutlet weak var PeopleLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var Mapview: MKMapView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var ride: Ride!
    var photos: Photos!
    var stringformatter = DateFormatter()
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "ridedd.png")!)
        if ride == nil{
            ride = Ride()
        }
        NameLabel.text = ride.name
        OriginLabel.text = ride.originname
        DestinationLabel.text = ride.destinationname
        PeopleLabel.text = ride.people
        PhoneLabel.text = ride.phone
        stringformatter.dateFormat = "MMM, dd, y h:mm a"
        TimeLabel.text = stringformatter.string(from: ride.Time)
        if ride.UserID == Auth.auth().currentUser?.email {
            DeleteButton.isHidden = false
        } else {
            DeleteButton.isHidden = true
        }
//        collectionView.delegate = self
//        collectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        photos.loadData(ride: ride){
//            self.collectionView.reloadData()
//        }
        let regionDistance = 10000 + ride.destinationlocation.distance(from: ride.originlocation)
        let region = MKCoordinateRegion(center: ride.origincoordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        print("^^^^^^\(regionDistance)")
        Mapview.setRegion(region, animated: true)
        updateMap()
    }

    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateMap(){
        Mapview.removeAnnotations(Mapview.annotations)
        let rideorigin = Rideorigin(locationname: ride.originname, coordinate: ride.origincoordinate)
        let ridedestination = Ridedestination(locationname: ride.destinationname, coordinate: ride.destinationcoordinate)
        Mapview.addAnnotation(rideorigin)
        Mapview.addAnnotation(ridedestination)
        Mapview.setCenter(ride.origincoordinate, animated: true)
    }
    
    @IBAction func Deletebuttonpressed(_ sender: UIButton) {
        ride.deleteData(ride: ride){(success) in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR")
            }
            
        }
    }
    

}
//extension RideDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return photos.photoArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! RideDetailCollectionViewCell
//        cell.photo = photos.photoArray[0]
//        return cell
//    }
//}
