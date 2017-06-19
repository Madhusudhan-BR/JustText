//
//  ViewController.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/19/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import  UIKit


class MainVC: UITableViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button1 = UIBarButtonItem(title: "Logout", style: .plain , target: self, action: #selector(logoutButtonPressed))
        self.navigationItem.leftBarButtonItem = button1
        
    }

    func logoutButtonPressed() {
        
        let loginVC = LoginVC()
        
        present(loginVC, animated: true, completion: nil)
        
        
    }

}

