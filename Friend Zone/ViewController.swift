//
//  ViewController.swift
//  Friend Zone
//
//  Created by Sarvad shetty on 2/9/19.
//  Copyright © 2019 Sarvad shetty. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, Storyboarded {
    
    //MARK: - Variables
    weak var coordinator:MainCoordinator?
    var friends = [Friend]()
    var selectedFriend = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Friend Zone"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.AddFriend))
        
        //load data
        LoadData()
    }
    
    //MARK: - Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = friends[indexPath.row].timezone
        dateFormatter.timeStyle = .short
        
        cell.textLabel?.text = friends[indexPath.row].name
        cell.detailTextLabel?.text = dateFormatter.string(from: Date())
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriend = indexPath.row
        coordinator?.configure(friends[selectedFriend])
    }
    
    @objc func AddFriend(){
        let newObject = Friend()
        friends.append(newObject)
        SaveData()
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 0)], with: .automatic)
        selectedFriend = friends.count - 1
        coordinator?.configure(newObject)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            friends.remove(at: indexPath.row)
            SaveData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func LoadData(){
        let userDefaults = UserDefaults.standard
        
        guard let savedFriendData = userDefaults.data(forKey: "friends") else{
            return
        }
        
        //decode data
        let decoder = JSONDecoder()
        
        guard let savedFriends = try? decoder.decode([Friend].self, from: savedFriendData) else{
            return
        }
        
        friends = savedFriends
    }
    
    func SaveData(){
        let encoder = JSONEncoder()
        
        guard let savedData = try? encoder.encode(friends) else{
            fatalError("unable to encode friends")
        }
        
        UserDefaults.standard.set(savedData, forKey: "friends")
        UserDefaults.standard.synchronize()
    }
    
    func update(fri:Friend){
        guard selectedFriend >= 0 else {return}
        friends[selectedFriend] = fri
        SaveData()
        tableView.reloadData()
    }
}

