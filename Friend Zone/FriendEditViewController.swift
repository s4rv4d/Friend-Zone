//
//  FriendEditViewController.swift
//  Friend Zone
//
//  Created by Sarvad shetty on 2/9/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class FriendEditViewController: UITableViewController, Storyboarded {
    
    //MARK: - Variables
    weak var coordinator: MainCoordinator?
    var friend:Friend!
    
    var timezones = [TimeZone]()
    var selectedTimeZone = 0
    
    var nameTextCell: TextVieTableViewCell?{
        let index = IndexPath(row: 0, section: 0)
        return tableView.cellForRow(at: index) as? TextVieTableViewCell
    }

    //MARK: - Main functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let identfiers = TimeZone.knownTimeZoneIdentifiers
        
        for identifier in identfiers{
            if let tmzone = TimeZone(identifier: identifier){
                timezones.append(tmzone)
            }
        }
        
        let now = Date()
        
        timezones.sort {
            let ourdiff = $0.secondsFromGMT(for:now)
            let other = $1.secondsFromGMT(for: now)
            
            if ourdiff == other{
                return $0.identifier < $1.identifier
            }else{
                return ourdiff < other
            }
        }
        
        selectedTimeZone = timezones.index(of: friend.timezone) ?? 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        coordinator?.updateData(friend)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //MARK: - Tableview functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return timezones.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath) as? TextVieTableViewCell else{
                fatalError("couldnt init cell")
            }
            cell.nameTextField.text = friend.name
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Time", for: indexPath)
            
            let timeZone = timezones[indexPath.row]
            cell.textLabel?.text = timeZone.identifier.replacingOccurrences(of: "_", with: " ")
            
            //time difference
            let timeDifference = timeZone.secondsFromGMT(for: Date())
            cell.detailTextLabel?.text = timeDifference.timeString()
            
            if indexPath.row == selectedTimeZone{
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
            return cell
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            StartEditingName()
        }else{
            SelectRow(indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Name your friend"
        }else{
            return "Select their time zones"
        }
    }
    
    func StartEditingName(){
        nameTextCell?.nameTextField.becomeFirstResponder()
    }
    
    func SelectRow(_ index:IndexPath){
        nameTextCell?.nameTextField.resignFirstResponder()
        
        for cell in tableView.visibleCells{
            cell.accessoryType = .none
        }
        
        selectedTimeZone = index.row
        friend.timezone = timezones[index.row]
        let selected = tableView.cellForRow(at: index)
        selected?.accessoryType = .checkmark
        tableView.deselectRow(at: index, animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func DidChange(_ sender: UITextField) {
        friend.name = sender.text ?? ""
    }
}
