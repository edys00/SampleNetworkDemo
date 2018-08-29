//
//  APIRoute.swift
//  SampleNetwork
//
//  Created by Edy on 29/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation

enum APIMethod : String {
    case get = "GET"
    case post = "POST"
}

enum APIRoute {
    case getPhotos
    case getPosts
    case getPostsBy(userId: Int)
    case submitPost(title: String, body: String, userId: Int)
    
    func getUrl() -> String {
        switch self {
        case .getPhotos:
            return "/photos"
        case .getPosts:
            return "/posts"
        case .getPostsBy(_):
            return "/posts"
        case .submitPost:
            return "/posts"
        }
    }
    
    func getParameters() -> [String: Any] {
        switch self {
        case .getPostsBy(let userId):
            return ["userId" : userId]
        case .submitPost(let title, let body, let userId):
            return ["title" : title,"body" : body,"userId" : userId]
        default:
            return [:]
        }
    }
    
    func getMethod() -> APIMethod {
        switch self {
        case .submitPost:
            return .post
        default:
            return .get
        }
    }
}
