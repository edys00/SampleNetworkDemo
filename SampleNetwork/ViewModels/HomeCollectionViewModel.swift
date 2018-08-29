//
//  HomeCollectionViewModel.swift
//  SampleNetwork
//
//  Created by Edy on 24/07/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation

class HomeCollectionViewModel {
    
    var items = [Photo]()
    
    init() {}
    
    func getItemsFromRequest(completion: @escaping (Bool) -> Void) {
        API.requestArray(route: .getPhotos, success: {
            (response: [Photo]) in
            self.items = response
            completion(true)
        }, failure: {
            (error) in
            completion(false)
        })
    }
    
}
