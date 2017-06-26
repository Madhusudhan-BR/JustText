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
        
        
    }

    func logoutButtonPressed() {
        
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        
        
        
        let loginVC = LoginVC()
        
        present(loginVC, animated: true, completion: nil)
        
        
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            perform(#selector(logoutButtonPressed), with: nil, afterDelay: 0 )
        }
        
    }

}

