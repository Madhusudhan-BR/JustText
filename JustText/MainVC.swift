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
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let button1 = UIBarButtonItem(title: "Logout", style: .plain , target: self, action: #selector(logoutButtonPressed))
        self.navigationItem.leftBarButtonItem = button1
        checkIfUserLoggedIn()
        let image = UIImage(named: "icons8-Address Book-50")
        tableView.register(cell.self, forCellReuseIdentifier: cellID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        observeUserMessages()
    }
    
    var messages = [Message]()
    var lastMessageDict = [String: Message]()

    
    func observeUserMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            //print(snapshot)
            let messageID = snapshot.key
            let msg_ref = Database.database().reference().child("Messages").child(messageID)
            msg_ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                if let messageDict = snapshot.value as? Dictionary<String, Any> {
                    let message = Message()
                    message._fromId = messageDict["fromId"] as! String
                    message._toId = messageDict["toId"] as! String
                    message._timestamp = messageDict["timestamp"] as! Int
                    message._text = messageDict["text"] as! String
                    // self.messages.append(message)
                    
                    if let toID = message._toId as? String {
                        self.lastMessageDict[toID] = message
                        self.messages = Array(self.lastMessageDict.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return message1._timestamp! > message2._timestamp!
                        })
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }

                
            })
            
            
        }, withCancel: nil)
        
    }
    
//            func observeMessages() {
//        let ref = Database.database().reference().child("Messages")
//        ref.observe(.childAdded, with: { (snapshot) in
//            if let messageDict = snapshot.value as? Dictionary<String, Any> {
//                let message = Message()
//                message._fromId = messageDict["fromId"] as! String
//                message._toId = messageDict["toId"] as! String
//                message._timestamp = messageDict["timestamp"] as! Int
//                message._text = messageDict["text"] as! String
//               // self.messages.append(message)
//                
//                if let toID = message._toId as? String {
//                    self.lastMessageDict[toID] = message
//                    self.messages = Array(self.lastMessageDict.values)
//                    self.messages.sort(by: { (message1, message2) -> Bool in
//                        return message1._timestamp! > message2._timestamp!
//                    })
//                    
//                }
//                
//                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }, withCancel: nil)
//    }
//    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        if let chatpartnerID = message.chatPartnerId() {
            
            let ref = Database.database().reference().child("users").child(chatpartnerID)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                //print(snaphot.value)
                
                if let withUserDict = snapshot.value as? Dictionary<String, Any> {
                    let user = User()
                    user.name = withUserDict["name"] as! String
                    user.id = chatpartnerID
                    user.email = withUserDict["email"] as! String
                    user.profileImageUrl = withUserDict["profileImageUrl"] as! String
                    
                    self.showChatVCWithUser(user: user)
                }
                
            }, withCancel: nil)
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! cell
        
        var message = messages[indexPath.row]
        
        
        
        
        if let chatPartnerID = message.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(chatPartnerID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let retrivedMessageDict = snapshot.value as? Dictionary<String,Any> {
                    cell.textLabel?.text = retrivedMessageDict["name"] as! String
                    
                    if let profileImageUrl = retrivedMessageDict["profileImageUrl"] as? String {
                        cell.profileImageView.loadImageFromCache(profileImageUrl: profileImageUrl)
                    }
                    
                    if let seconds = message._timestamp{
                        let timestamp = Date(timeIntervalSince1970: TimeInterval(seconds))
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "hh:mm:ss a"
                        cell.timeLabel.text = dateFormatter.string(from: timestamp)
                    }
                    
                }
            }, withCancel: nil)
        }
        
        cell.detailTextLabel?.text = message._text
       // cell.textLabel?.text = message._toId
        
        return cell
    }
    
    func setupNavBar(user: User){
        // self.navigationItem.title = user.name
        
        messages.removeAll()
        lastMessageDict.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
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
        
        //newtitleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatVC)))
    }
    
    func showChatVCWithUser(user: User) {
        
        let chatLogVC = ChatLogVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogVC.user = user 
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

