//
//  photos.swift
//  UberShare
//
//  Created by wxt on 4/28/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import Foundation
import Firebase
import FirebaseUI

class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(ride: Ride, completed: @escaping ()->()) {
        guard ride.documentID != "" else {
            return
        }
        let storage = Storage.storage()
        db.collection("rides").document(ride.documentID).collection("photos").addSnapshotListener {(querySnapshot, error) in
            guard error == nil else {
                print("^^^^^^^^^^^^^^^^^^^^^^ERROR")
                return completed()
            }
            self.photoArray = []
            var loadAttempts = 0
            let storageRef = storage.reference().child(ride.documentID)
            for document in querySnapshot!.documents {
                let photo = Photo(dictionary: document.data())
                photo.documentUUID = document.documentID
                self.photoArray.append(photo)

                let photoRef = storageRef.child(photo.documentUUID)
                photoRef.getData(maxSize: 25 * 1025 * 1025) {
                    data, error in
                    if let error = error {
                        loadAttempts += 1
                        if loadAttempts >= (querySnapshot!.count){
                            return completed()
                        }
                    }else{
                        let image = UIImage(data: data!)
                        photo.image = image!
                        loadAttempts += 1
                        if loadAttempts >= (querySnapshot!.count){
                            return completed()
                        }
                    }
                }
            }
        }
                 completed()
    }
}


