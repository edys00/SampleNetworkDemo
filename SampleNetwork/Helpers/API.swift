//
//  API.swift
//  SampleNetwork
//
//  Created by Edy on 03/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

struct API {
    
    static let baseUrl = "https://jsonplaceholder.typicode.com"
    
    static func request<T: Codable>(route: APIRoute, showLoading: Bool = false, success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
        let requestUrl = self.getUrlRequest(route: route, method: route.getMethod(), params: route.getParameters())
        
        showLoading ? showProgress() : nil

        let task = URLSession.shared.dataTask(with: requestUrl) {(data, response, error) in
            hideProgress()
            do {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if statusCode >= 200 && statusCode <= 400 {
                    let jsonData = try JSONDecoder().decode(T.self, from: data!)
                    success(jsonData)
                }
                else if statusCode == 401 {
                    print("Unauthorized")
                }
                else {
                    print("Some Error Occurred")
                }
            }
            catch {
                print("ERROR",error)
                failure(error)
            }
        }
        
        task.resume()
    }
    
    static func request(route: APIRoute, showLoading: Bool = false, success: @escaping (Bool) -> Void, failure: @escaping (Error) -> Void) {
        let requestUrl = self.getUrlRequest(route: route, method: route.getMethod(), params: route.getParameters())
        
        showLoading ? showProgress() : nil
        
        let task = URLSession.shared.dataTask(with: requestUrl) {(data, response, error) in
            hideProgress()
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode >= 200 && statusCode <= 400 {
                success(true)
            }
            else if statusCode == 401 {
                print("Unauthorized")
            }
            else {
                print("Some Error Occurred")
            }
            if let error = error {
                failure(error)
            }
        }
        
        task.resume()
    }
    
    static func requestArray<T: Codable>(route: APIRoute, showLoading: Bool = false, success: @escaping ([T]) -> Void, failure: @escaping (Error) -> Void) {
        let requestUrl = self.getUrlRequest(route: route, method: route.getMethod(), params: route.getParameters())
        
        showLoading ? showProgress() : nil
        
        let task = URLSession.shared.dataTask(with: requestUrl) {(data, response, error) in
            hideProgress()
            do {
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                if statusCode >= 200 && statusCode <= 400 {
                    let jsonData = try JSONDecoder().decode([T].self, from: data!)
                    success(jsonData)
                }
                else if statusCode == 401 {
                    print("Unauthorized")
                }
                else {
                    print("Some Error Occurred")
                }
            }
            catch {
                print("ERROR",error)
                failure(error)
            }
        }
        
        task.resume()
    }
    
    static func getUrlRequest(route: APIRoute, method: APIMethod, params: [String: Any]) -> URLRequest {
        let appendedUrl = API.baseUrl + route.getUrl()
        var url = URL(string: appendedUrl)
        if method == .post {
            url = URL(string: "http://dummy.restapiexample.com/api/v1/create")
        }
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if method == .get {
            var components = URLComponents(string: appendedUrl)
            components?.queryItems = params.map { (arg) -> URLQueryItem in
                let (key, value) = arg
                return URLQueryItem(name: key, value: "\(value)")
            }
            let updatedPercentEncodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            components?.percentEncodedQuery = updatedPercentEncodedQuery
            urlRequest = URLRequest(url: (components?.url!)!)
        }
        else {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        return urlRequest
    }
    
    static func showProgress() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let progressView = UIView(frame: topController.view.frame)
            progressView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
            progressView.tag = 999
            progressView.alpha = 0.6
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            activityIndicator.center.x = progressView.center.x
            activityIndicator.center.y = progressView.center.y
            activityIndicator.startAnimating()
            progressView.addSubview(activityIndicator)
            topController.view.addSubview(progressView)
        }
    }
    
    static func hideProgress() {
        DispatchQueue.main.async {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
               
                for view in topController.view.subviews {
                    if view.tag == 999 {
                        view.removeFromSuperview()
                    }
                }
                
            }
        }
    }
    
}



