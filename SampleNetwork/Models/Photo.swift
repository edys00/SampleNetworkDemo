//
//  Photo.swift
//  SampleNetwork
//
//  Created by Edy on 14/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation

struct Photo: Codable {
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}
