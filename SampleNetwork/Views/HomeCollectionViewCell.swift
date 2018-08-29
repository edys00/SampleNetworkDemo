//
//  HomeCollectionViewCell.swift
//  SampleNetwork
//
//  Created by Edy on 22/07/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentImageView.image = nil
    }
    
    func setupWith(item: Photo) {
        self.contentImageView.downloadedFrom(link: item.thumbnailUrl, contentMode: .scaleToFill)
    }
}
