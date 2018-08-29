//
//  HomeTableViewController.swift
//  SampleNetwork
//
//  Created by Edy on 03/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewController: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var homeTableViewModel: HomeTableViewModel = HomeTableViewModel()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "LIST NEWS"
        let tableViewCell = UINib(nibName: "HomeTableViewCell", bundle: nil)
        homeTableView.rowHeight = UITableViewAutomaticDimension
        homeTableView.estimatedRowHeight = 100.0
        homeTableView.register(tableViewCell, forCellReuseIdentifier: "cell")
        requestData()
        addRefreshControl()
    }
    
    fileprivate func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(hexFromString: "#3498db")
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        homeTableView.addSubview(refreshControl)
    }
    
    @objc func requestData() {
        homeTableViewModel.getItemsFromRequest(completion: {
            (finished) in
            if finished {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.homeTableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "SubmitNewPostViewController") as! SubmitNewPostViewController
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overCurrentContext
        let dimScreenView = UIView(frame: self.view.bounds)
        dimScreenView.backgroundColor = UIColor.black
        dimScreenView.alpha = 0.3
        dimScreenView.tag = 100
        self.tabBarController?.view.addSubview(dimScreenView)
        self.tabBarController?.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        let primaryColor = UIColor(hexFromString: "#3498db")
        let infoLabel = getInfoLabel()
        
        // Initiate View Controller for Pop Over
        let popoverContent = UIViewController()
        popoverContent.preferredContentSize = CGSize(width: 240.0, height: infoLabel.frame.size.height + 20.0)
        popoverContent.view.backgroundColor = primaryColor
        popoverContent.view.addSubview(infoLabel)
        
        // Embed Navigation to View Controller
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverContent.navigationController?.isNavigationBarHidden = true
        
        // Settings for PopoverPresentationController
        let popover = nav.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = sender
        popover?.permittedArrowDirections = [.up]
        popover?.backgroundColor = primaryColor
        popover?.sourceRect = sender.bounds
        
        self.present(nav, animated: true, completion: nil)
    }
    
    func getInfoLabel() -> UILabel {
        let newLabel = UILabel()
        newLabel.frame = CGRect(x: 10, y: 10, width: 220, height: 140)
        newLabel.textAlignment = .justified
        newLabel.numberOfLines = 0
        newLabel.lineBreakMode = .byWordWrapping
        newLabel.textColor = .white
        newLabel.font = UIFont(name: "Verdana-Bold", size: 14.0)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.hyphenationFactor = 1.0
        
        let hyphenAttribute = [
            NSAttributedStringKey.paragraphStyle : paragraphStyle,
            ] as [NSAttributedStringKey : Any]
        
        let attributedString = NSMutableAttributedString(string: "This view is used to show a list of data retrieved from the server using GET request displayed in a table view.", attributes: hyphenAttribute)
        newLabel.attributedText = attributedString
        newLabel.sizeToFit()
        
        return newLabel
    }
    
}

extension HomeTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeTableViewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        
        let item = homeTableViewModel.items[indexPath.row]
        cell.setupWith(item: item)
        
        return cell
    }
}

extension HomeTableViewController: SubmitNewPostDelegate {
    func didDismiss(byCancelling: Bool) {
        removeDimScreen()
        if !byCancelling {
            requestData()
        }
        self.showDefaultAlert(title: "Success", message: "Request submitted successfully!")
    }
    
    func removeDimScreen() {
        for view in (self.tabBarController?.view.subviews)! {
            if view.tag == 100 {
                view.removeFromSuperview()
                break
            }
        }
    }
}

extension HomeTableViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
