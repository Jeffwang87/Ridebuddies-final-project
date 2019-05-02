//
//  Rides.swift
//  UberShare
//
//  Created by wxt on 4/20/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI

class Rides {
    var RideArray = [Ride]()
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    func loadData(completed: @escaping ()->()) {
        db.collection("rides").addSnapshotListener {(querySnapshot, error) in
            guard error == nil else {
                print("ERROR")
                return completed()
            }
            self.RideArray = []
            for document in querySnapshot!.documents {
                let ride = Ride(dictionary: document.data())
                ride.documentID = document.documentID
                self.RideArray.append(ride)
            }
            completed()
        }
    }
}
