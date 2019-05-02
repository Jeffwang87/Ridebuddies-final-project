//
//  RideDetailCollectionViewCell.swift
//  UberShare
//
//  Created by wxt on 4/29/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import UIKit

class RideDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImagePhoto: UIImageView!
    var photo: Photo! {
        didSet{
            ImagePhoto.image = photo.image
        }
    }
}
