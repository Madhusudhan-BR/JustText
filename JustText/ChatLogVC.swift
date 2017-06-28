//
//  ChatLogVC.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/27/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase


class ChatLogVC: UICollectionViewController,UITextFieldDelegate {
    
    let inputTextFiled = UITextField()
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user?.name
        collectionView?.backgroundColor = UIColor.white
        
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
       // containerView.backgroundColor = UIColor.red
        view.addSubview(containerView)
        
        //containerview constraints 
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        //Send button 
        
        let sendButton = UIButton(type:  .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        containerView.addSubview(sendButton)
        
        //constraints for send 
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        inputTextFiled.delegate = self
        inputTextFiled.translatesAutoresizingMaskIntoConstraints = false
        inputTextFiled.placeholder = "Enter Message..."
        containerView.addSubview(inputTextFiled)
        
        //constraints for inputtextfield 
        
        inputTextFiled.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextFiled.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        inputTextFiled.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextFiled.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
        //seperator view 
        let seperatorrView = UIView()
        seperatorrView.translatesAutoresizingMaskIntoConstraints = false
        seperatorrView.backgroundColor = UIColor(red: 220/250, green: 220/250, blue: 220/250, alpha: 1)
        containerView.addSubview(seperatorrView)
        
        //containerview constraints
        
        seperatorrView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorrView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorrView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorrView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func handleSend() {
        
        let messages_ref = Database.database().reference().child("Messages").childByAutoId()
        
        if let inputText = inputTextFiled.text {
            var toID = user?.id
            var fromiD = Auth.auth().currentUser!.uid
            let timestamp : Int = Int(NSDate().timeIntervalSince1970)
            let values = ["text" : inputText, "toId" : user?.id, "fromId" : fromiD, "timestamp" : timestamp] as [String : Any]
            messages_ref.updateChildValues(values)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
