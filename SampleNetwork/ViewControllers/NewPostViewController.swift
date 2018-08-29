//
//  NewPostViewController.swift
//  SampleNetwork
//
//  Created by Edy on 24/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

class SubmitNewPostViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    
    var delegate: SubmitNewPostDelegate?
    var textViewIsEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor(hexFromString: "#C7C7CD").cgColor
        closeButton.transform = closeButton.transform.rotated(by: CGFloat(.pi/1.35))
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        if let title = titleTextField.text, let descriptionText = descriptionTextView.text {
            API.request(route: .submitPost(title: title, body: descriptionText, userId: 1),
                showLoading: true, success: {
                (response) in
                if (response) {
                    self.dismiss(animated: true, completion: {
                        self.delegate?.didDismiss(byCancelling: false)
                    })
                }
            }, failure: {
                (error) in
                self.showDefaultAlert(title: "Sorry", message: error.localizedDescription)
            })
            
        }
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: {
            self.delegate?.didDismiss(byCancelling: true)
        })
    }
    
}

extension SubmitNewPostViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textViewIsEmpty = textView.text.count == 0
        if textView.text.count == 0 {
            textView.text = "Enter your description here"
            textView.textColor = UIColor(hexFromString: "#C7C7CD")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewIsEmpty {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}

protocol SubmitNewPostDelegate {
    func didDismiss(byCancelling: Bool)
}
