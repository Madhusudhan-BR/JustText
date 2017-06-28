//
//  NewMessageVC.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/26/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class NewMessageVC: UITableViewController {
    var users =  [User]()
    let cellID = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cell.self, forCellReuseIdentifier: cellID)
     
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        fetchUsers()
        
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapchot) in
            if let usersDict = snapchot.value as? [String: Any] {
                let user = User()
                user.id = snapchot.key 
                user.name = usersDict["name"] as! String
                user.email = usersDict["email"] as! String
                user.profileImageUrl = usersDict["profileImageUrl"] as! String
                self.users.append(user)
                print("MADHU : New user \(user.name)")
                
//                DispatchQueue.async(group: DispatchQueue.main,
//                                    execute: {
//                                        self.tableView.reloadData()
//                }) 
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }
        }, withCancel: nil)
    }

    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var mainVC : MainVC?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { 
            //print("dismissed") 
            let user = self.users[indexPath.row]
            
            self.mainVC?.showChatVCWithUser(user: user)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! cell
        
        var user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        if let profileImageUrl = user.profileImageUrl as? String{

//            
            cell.profileImageView.loadImageFromCache(profileImageUrl: profileImageUrl)
            
        }
        
        
        
        return cell
    }
}


