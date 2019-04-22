//
//  DogViewCell.swift
//  DogBreed
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import UIKit
import Kingfisher

class DogViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImageUri(_ uri: String?) {
        
        if let uri = uri, let url = URL(string: uri) {
            image.kf.setImage(with: url)
        }
    }

}
