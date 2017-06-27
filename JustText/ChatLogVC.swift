//
//  ChatLogVC.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/27/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class ChatLogVC: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat VC"
        collectionView?.backgroundColor = UIColor.white
        
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.red
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
        
    }
}
