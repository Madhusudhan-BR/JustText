//
//  ViewController.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/19/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import  UIKit
import  Firebase

class MainVC: UITableViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button1 = UIBarButtonItem(title: "Logout", style: .plain , target: self, action: #selector(logoutButtonPressed))
        self.navigationItem.leftBarButtonItem = button1
        checkIfUserLoggedIn()
        let image = UIImage(named: "icons8-Address Book-50")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
    }
    
    func handleNewMessage() {
        let newMessageVC = NewMessageVC()
        let navController = UINavigationController(rootViewController: newMessageVC)
        present(navController, animated: true, completion: nil )
        
    }

    func logoutButtonPressed() {
        
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        
        
        
        let loginVC = LoginVC()
        loginVC.mainVC = self
        present(loginVC, animated: true, completion: nil)
        
        
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            //perform(#selector(logoutButtonPressed), with: nil, afterDelay: 0 )
              let loginVC = LoginVC()
            present(loginVC, animated: true, completion: nil)

        } else {
            handleLoggedInUser()
        }
        
    }
    
    func handleLoggedInUser() {
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
           // print(snapshot) 
            
            if let userInfoDict = snapshot.value as? Dictionary<String, Any> {
                self.navigationItem.title = userInfoDict["name"] as? String 
            }
            
        })
        
    }

}

