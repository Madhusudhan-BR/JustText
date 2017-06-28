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
    
    func setupNavBar(user: User){
        // self.navigationItem.title = user.name
        
        let newtitleView = UIView()
        
        newtitleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //newtitleView.backgroundColor = UIColor.blue
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        newtitleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        containerView.addSubview(profileImageView)
        if let profileImgUrl = user.profileImageUrl as? String {
            
            profileImageView.loadImageFromCache(profileImageUrl: profileImgUrl)
        }
        //constraints for the image view
        
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let usernameLabel = UILabel()
        containerView.addSubview(usernameLabel)
        usernameLabel.text = user.name
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: newtitleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: newtitleView.centerXAnchor).isActive = true
        
        self.navigationItem.titleView = newtitleView
        
        newtitleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatVC)))
    }
    
    func showChatVC() {
        
        let chatLogVC = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        self.navigationController?.pushViewController(chatLogVC, animated: true)
        
    }
    
    func handleNewMessage() {
        let newMessageVC = NewMessageVC()
        newMessageVC.mainVC = self 
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
                let user = User()
                user.name = userInfoDict["name"] as! String
                user.email = userInfoDict["email"] as! String
                user.profileImageUrl = userInfoDict["profileImageUrl"] as! String
                
                //  self.navigationItem.title = userInfoDict["name"] as? String
                
                self.setupNavBar(user: user)
            }
            
        })
        
    }
    
}

