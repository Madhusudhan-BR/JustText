//
//  ChatLogVC.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/27/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase


class ChatLogVC: UICollectionViewController,UITextFieldDelegate,UICollectionViewDelegateFlowLayout {
    
    let inputTextFiled = UITextField()
    var user : User? {
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
        
    }
    
    var messages =  [Message]()
    
    func observeMessages(){
        guard  let uid = Auth.auth().currentUser?.uid  else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messages_ref = Database.database().reference().child("Messages").child(messageID)
            messages_ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let messageDict = snapshot.value as? [ String : Any ] else {
                    return
                }
                
                let message = Message()
                message._fromId = messageDict["fromId"] as! String
                message._text = messageDict["text"] as! String
                message._toId  = messageDict["toId"] as! String
                message._timestamp = messageDict["timestamp"] as! Int
                
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
                
                
             }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        setupInputComponents()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        cell.textView.text = message._text
        
        if let profileImageUrl = user?.profileImageUrl {
            cell.profileImageView.loadImageFromCache(profileImageUrl: profileImageUrl)
        }
        
        if message._fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        }
        else {
            cell.bubbleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textView.textColor = UIColor.black
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: message._text!).width + 32
  
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = messages[indexPath.row]._text {
            height = estimatedFrameForText(text: text).height + 20
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func estimatedFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
       containerView.backgroundColor = UIColor.white
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
        
        if let inputText = inputTextFiled.text, inputTextFiled.text != ""  {
            var toID = user?.id
            var fromiD = Auth.auth().currentUser!.uid
            let timestamp : Int = Int(NSDate().timeIntervalSince1970)
            let values = ["text" : inputText, "toId" : user?.id, "fromId" : fromiD, "timestamp" : timestamp] as [String : Any]
            //messages_ref.updateChildValues(values) 
            
            messages_ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                self.inputTextFiled.text = ""
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromiD)
                let messageID = messages_ref.key
                userMessagesRef.updateChildValues([messageID : 1])
                
                let receipientMessagesRef = Database.database().reference().child("user-messages").child(toID!)
                receipientMessagesRef.updateChildValues([messageID: 1])
                
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
