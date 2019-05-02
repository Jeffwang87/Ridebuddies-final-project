//
//  RidePhotosCollectionViewCell.swift
//  UberShare
//
//  Created by wxt on 4/29/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import UIKit

class RidePhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PhotoImage: UIImageView!
    var photo: Photo! {
        didSet{
            PhotoImage.image = photo.image
        }
    }
}
