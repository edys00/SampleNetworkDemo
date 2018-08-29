//
//  HomeTableViewModel.swift
//  SampleNetwork
//
//  Created by Edy on 03/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation

class HomeTableViewModel {
    
    var items = [Post]()
    
    init() {}
    
    func getItemsFromRequest(completion: @escaping (Bool) -> Void) {
        API.requestArray(route: .getPostsBy(userId: 1), success: {
            (response: [Post]) in
            self.items = response
            completion(true)
        }, failure: {
            (error) in
            completion(false)
        })
    }
    
}
