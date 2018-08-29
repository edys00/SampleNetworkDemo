//
//  HomeToDoListViewController.swift
//  SampleNetwork
//
//  Created by Edy on 14/08/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import Foundation
import UIKit

class HomeToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoListTableView: UITableView!
    
    var toDoLists = [(String, Bool)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TO DO LIST"
        toDoListTableView.backgroundColor = .clear
        toDoListTableView.separatorColor = UIColor.white
        toDoListTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        let startColor = UIColor(hexFromString: "#3498db")
        let endColor = UIColor(hexFromString: "#3498db", alpha: 0.4)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        view.layer.addSublayer(gradientLayer)
        view.bringSubview(toFront: toDoListTableView)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        showInputAlert()
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let isEditing = toDoListTableView.isEditing
        let titleText = isEditing ? "Edit" : "Done"
        sender.title =  titleText
        toDoListTableView.setEditing(!isEditing, animated: true)
    }
    
    
    func showInputAlert() {
        let alertController = UIAlertController(title: "Enter your task", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {
            (textField) in
            textField.placeholder = "Type here.."
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            (alertAction) in
            let textField = alertController.textFields![0]
            guard let inputText = textField.text else { return }
            if inputText.count > 0 {
                self.toDoLists.append((inputText, false))
                self.toDoListTableView.reloadData()
            }
        })
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension HomeToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoLists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")

        let taskName = toDoLists[indexPath.row].0
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: taskName)

        attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        if toDoLists[indexPath.row].1 {
            cell.textLabel?.attributedText = attributeString
        }
        else {
            cell.textLabel?.text = taskName
        }
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoLists[indexPath.row].1 = !toDoLists[indexPath.row].1
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && tableView.isEditing {
            toDoLists.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let destinationData = toDoLists[destinationIndexPath.row]
        let sourceData = toDoLists[sourceIndexPath.row]
        toDoLists[sourceIndexPath.row] = destinationData
        toDoLists[destinationIndexPath.row] = sourceData
    }
}
