//
//  HomeCollectionViewController.swift
//  SampleNetwork
//
//  Created by Edy on 22/07/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

class HomeCollectionViewController : UIViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    var homeCollectionViewModel: HomeCollectionViewModel = HomeCollectionViewModel()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GRID"
        let collectionViewCell = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        homeCollectionView.register(collectionViewCell, forCellWithReuseIdentifier: "cell")
        requestData()
        addRefreshControl()
    }
    
    
    fileprivate func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(hexFromString: "#3498db")
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        homeCollectionView.addSubview(refreshControl)
    }
    
    @objc func requestData() {
        homeCollectionViewModel.getItemsFromRequest(completion: {
            (finished) in
            if finished {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.homeCollectionView.reloadData()
                }
            }
        })
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
        
        let attributedString = NSMutableAttributedString(string: "This view is used to show a grid of images retrieved from the server using GET request displayed in a collection view.", attributes: hyphenAttribute)
        newLabel.attributedText = attributedString
        newLabel.sizeToFit()
        
        return newLabel
    }
}

extension HomeCollectionViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeCollectionViewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        
        let item = homeCollectionViewModel.items[indexPath.item]
        cell.setupWith(item: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let newWidth = CGFloat(collectionView.frame.size.width / 3)
        return CGSize(width: newWidth,height: newWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
}

extension HomeCollectionViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
