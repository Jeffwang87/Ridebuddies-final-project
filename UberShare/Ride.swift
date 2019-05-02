//
//  Ride.swift
//  UberShare
//
//  Created by wxt on 4/24/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase
import FirebaseUI
import MapKit


class Ride: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var placename: String
    var originaddress: String
    var UserID: String
    var destinationaddress: String
    var name: String
    var origincoordinate:CLLocationCoordinate2D
    var destinationcoordinate: CLLocationCoordinate2D
    var originname: String
    var destinationname: String
    var people: String
    var phone: String
    var Time: Date
    var postingUserID: String
    var documentID: String
    var originlongtitude: CLLocationDegrees {
        return origincoordinate.longitude
    }
    
    var originlatitude: CLLocationDegrees {
        return origincoordinate.latitude
    }
    var destinationlongtitude: CLLocationDegrees {
        return destinationcoordinate.longitude
    }
    
    var destinationlatitude: CLLocationDegrees {
        return destinationcoordinate.latitude
    }
    var dictionary: [String: Any]{
        let timeIntervalDate = Time.timeIntervalSince1970
        return ["name": name,  "UserID": UserID, "originaddress": originaddress, "destinationaddress": destinationaddress, "originname": originname, "destinationname": destinationname, "originlongtitude": originlongtitude, "originlatitude": originlatitude,"destinationlongtitude": destinationlongtitude, "destinationlatitude": destinationlatitude, "people": people, "phone": phone, "Time": timeIntervalDate, "postingUserID": postingUserID]
    }
    
    var originlocation: CLLocation {
        return CLLocation(latitude: originlatitude, longitude: originlongtitude)
    }
    var destinationlocation: CLLocation{
        return CLLocation(latitude: destinationlatitude, longitude: destinationlongtitude)
    }
    
    init(name: String, UserID: String, originaddress: String, destinationaddress: String, placename: String, coordinate: CLLocationCoordinate2D, origincoordinate: CLLocationCoordinate2D, destinationcoordinate:CLLocationCoordinate2D, originname: String, destinationname: String, people: String, phone: String, Time: Date, postingUserID: String, documentID: String){
        self.name = name
        self.placename = placename
        self.UserID = UserID
        self.originaddress = originaddress
        self.destinationaddress = destinationaddress
        self.coordinate = coordinate
        self.origincoordinate = origincoordinate
        self.destinationcoordinate = destinationcoordinate
        self.originname = originname
        self.destinationname = destinationname
        self.people = people
        self.phone = phone
        self.Time = Time
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience override init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "unknown User"
        self.init(name: "", UserID: currentUserID, originaddress: "", destinationaddress: "", placename:"", coordinate: CLLocationCoordinate2D(), origincoordinate: CLLocationCoordinate2D(), destinationcoordinate: CLLocationCoordinate2D(), originname: "", destinationname: "", people: "", phone: "", Time: Date(), postingUserID: "", documentID: "")
    }
   
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let originname = dictionary["originname"] as! String? ?? ""
        let placename = ""
        let UserID = dictionary["UserID"] as! String? ?? ""
        let originaddress = dictionary["originaddress"] as! String? ?? ""
        let destinationaddress = dictionary["destinationaddress"] as! String? ?? ""
        let destinationname = dictionary["destinationname"] as! String? ?? ""
        let originlatitude = dictionary["originlatitude"] as! CLLocationDegrees? ?? 0.0
        let originlongtitude = dictionary["originlongtitude"] as! CLLocationDegrees? ?? 0.0
        let origincoordinate = CLLocationCoordinate2D(latitude: originlatitude, longitude: originlongtitude)
        let destinationlatitude = dictionary["destinationlatitude"] as! CLLocationDegrees? ?? 0.0
        let destinationlongtitude = dictionary["destinationlongtitude"] as! CLLocationDegrees? ?? 0.0
        let destinationcoordinate = CLLocationCoordinate2D(latitude: destinationlatitude, longitude: destinationlongtitude)
        let people = dictionary["people"] as! String? ?? ""
        let phone = dictionary["phone"] as! String? ?? ""
        let timeIntervalDate = dictionary["Time"] as! TimeInterval? ?? TimeInterval()
        let Time = Date(timeIntervalSince1970: timeIntervalDate)
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(name: name, UserID: UserID, originaddress: originaddress, destinationaddress: destinationaddress, placename: placename, coordinate: CLLocationCoordinate2D(), origincoordinate: origincoordinate, destinationcoordinate: destinationcoordinate, originname: originname, destinationname: destinationname, people: people, phone: phone, Time: Time, postingUserID: postingUserID, documentID: "")
    }
    func saveData(completed: @escaping(Bool) -> ()) {
        let db = Firestore.firestore()
        
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            return completed(false)
        }
        self.postingUserID = postingUserID
        let dataToSave = self.dictionary
        if self.documentID != ""{
            let ref = db.collection("rides").document(self.documentID)
            ref.setData(dataToSave) {(error) in
                if let error = error {
                    completed(false)
                } else {
                    completed(true)
                }
                
            }
        }else {
            var ref: DocumentReference? = nil
            ref = db.collection("rides").addDocument(data: dataToSave) { error
                in   if let error = error {
                    completed(false)
                } else {
                    self.documentID = ref!.documentID
                    completed(true)
                }
            }
            
        }
    }
    
    func deleteData(ride: Ride, completed: @escaping(Bool) -> ()){
        let db = Firestore.firestore()
        db.collection("rides").document(ride.documentID).delete()
            { error in
                if let error = error {
                    print("ERROR: deleting review documentID")
                    completed(false)
                }else {
                    completed(true)
                    }
                }
        }
    
}

