//
//  UIViewController.swift
//  SampleNetwork
//
//  Created by Edy on 27/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    #if DEBUG
    @objc func injected() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewDidLoad), name: NSNotification.Name(rawValue: "INJECTION_BUNDLE_NOTIFICATION"), object: nil)
    }
    #endif
    
    func showDefaultAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func swapRootView() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = homeStoryboard.instantiateInitialViewController()
        guard let window = UIApplication.shared.keyWindow else { return }
        
        guard let rootViewController = window.rootViewController else { return }
        
        vc!.view.frame = rootViewController.view.frame
        vc!.view.layoutIfNeeded()
        
        UIView.transition(with: window, duration: 1.0, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: { completed in
        })
    }
}
