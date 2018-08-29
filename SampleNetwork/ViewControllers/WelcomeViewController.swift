//
//  WelcomeViewController.swift
//  SampleNetwork
//
//  Created by Edy on 28/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.layer.borderWidth = 1
        continueButton.layer.borderColor = UIColor.white.cgColor
        continueButton.layer.cornerRadius = 10
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let translateYUpAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        translateYUpAnimation.fromValue = 80
        translateYUpAnimation.toValue = logoImageView.bounds.origin.y
        translateYUpAnimation.duration = 2
        translateYUpAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.0
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 2
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.duration = 2
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        let translateYDownAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        translateYDownAnimation.fromValue = -40
        translateYDownAnimation.toValue = authorLabel.bounds.origin.y
        translateYDownAnimation.duration = 2
        translateYDownAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        logoImageView.layer.add(translateYUpAnimation, forKey: "translateUp")
        welcomeLabel.layer.add(opacityAnimation, forKey: "opacity")
        descriptionLabel.layer.add(opacityAnimation, forKey: "opacity")
        authorLabel.layer.add(opacityAnimation, forKey: "opacity")
        authorLabel.layer.add(translateYDownAnimation, forKey: "translateDown")
        continueButton.layer.add(scaleAnimation, forKey: "scale")
        
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        self.swapRootView()
    }
    
}
