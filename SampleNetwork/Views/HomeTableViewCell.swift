//
//  HomeTableViewCell.swift
//  SampleNetwork
//
//  Created by Edy on 03/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setupWith(item: Post) {
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.body
    }
}
