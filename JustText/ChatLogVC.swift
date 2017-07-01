//
//  ChatLogVC.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/27/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase


class ChatLogVC: UICollectionViewController,UITextFieldDelegate,UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let inputTextFiled = UITextField()
    
    var user : User? {
        didSet{
            navigationItem.title = user?.name
            observeMessages()
        }
        
    }
    
    var messages =  [Message]()
    
    func observeMessages(){
        guard  let uid = Auth.auth().currentUser?.uid, let toID = user?.id  else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid).child(toID)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageID = snapshot.key
            let messages_ref = Database.database().reference().child("Messages").child(messageID)
            messages_ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let messageDict = snapshot.value as? [ String : Any ] else {
                    return
                }
                
                let message = Message(dictionary : messageDict)
//                message._fromId = messageDict["fromId"] as? String
//                message._text = messageDict["text"] as? String
//                message._toId  = messageDict["toId"] as? String
//                message._timestamp = messageDict["timestamp"] as? Int
//                message.downloadUrl = messageDict["downloadUrl"] as? String
//                
                
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
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
//        
//        setupInputComponents()
//        setupKeyboardObservers()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var inputContainerView : UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        //containerView.backgroundColor = UIColor.brown
        containerView.backgroundColor = UIColor.white
        
        let uploadImageView = UIImageView()
        uploadImageView.image = UIImage(named: "ic_insert_photo_48pt")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(uploadImageView)
        
        //constraints 
        
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadPic)))
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
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
        
        self.inputTextFiled.delegate = self
        self.inputTextFiled.translatesAutoresizingMaskIntoConstraints = false
        self.inputTextFiled.placeholder = "Enter Message..."
        containerView.addSubview(self.inputTextFiled)
        
        //constraints for inputtextfield
        
        self.inputTextFiled.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextFiled.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        self.inputTextFiled.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextFiled.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        
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
        
        return containerView
    }()
    
    func handleUploadPic() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true 
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var imageSelectedFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            imageSelectedFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageSelectedFromPicker = originalImage
        }
        
        if let selectedImage = imageSelectedFromPicker {
            //profileImage.image = selectedImage
            uploadImageToFirebaseDB(image : selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func uploadImageToFirebaseDB(image : UIImage) {
        let imageName = NSUUID().uuidString
        
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
        ref.putData(uploadData, metadata: nil) { (metadata, error) in
            
            
            if error != nil {
                print(error)
                return
            }
            
            if let downloadURL = metadata?.downloadURL()?.absoluteString {
                
                self.uploadMessageWithImageUrl(url : downloadURL, image: image)
            }
            
            
        }
        }
        
    }

    func uploadMessageWithImageUrl(url : String, image: UIImage){
        let messages_ref = Database.database().reference().child("Messages").childByAutoId()
        
        
            var toID = user?.id
            var fromiD = Auth.auth().currentUser!.uid
            let timestamp : Int = Int(NSDate().timeIntervalSince1970)
        let values = [ "toId" : user?.id, "fromId" : fromiD, "timestamp" : timestamp , "downloadUrl" : url, "imageHeight" : image.size.height, "imageWidth" : image.size.width] as [String : Any]
            //messages_ref.updateChildValues(values)
            
            messages_ref.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                self.inputTextFiled.text = ""
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromiD).child(toID!)
                let messageID = messages_ref.key
                userMessagesRef.updateChildValues([messageID : 1])
                
                let receipientMessagesRef = Database.database().reference().child("user-messages").child(toID!).child(fromiD)
                receipientMessagesRef.updateChildValues([messageID: 1])
                
            })
            
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView?  {
        get {
            
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupKeyboardObservers()  {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        print(keyboardFrame?.height)
        
        containerViewBottomAnchor?.constant = -(keyboardFrame?.height)!
        UIView.animate(withDuration: keyboardDuration!) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue

        
        containerViewBottomAnchor?.constant = 0
        
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
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
        cell.textView.text = message.text
        
        if let profileImageUrl = user?.profileImageUrl {
            cell.profileImageView.loadImageFromCache(profileImageUrl: profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
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
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 32
        } else if message.downloadUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
        }
        
        if let imageURL = message.downloadUrl {
            cell.messageImageView.loadImageFromCache(profileImageUrl: imageURL)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear 
        } else {
            cell.messageImageView.isHidden = true
        }
  
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.row]
        
        if let text = message.text {
            height = estimatedFrameForText(text: text).height + 20
        } else if let imageHeight = message.imageHeight?.floatValue, let imageWidth = message.imageWidth?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        let width = UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    func estimatedFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    
    var containerViewBottomAnchor : NSLayoutConstraint?
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
       containerView.backgroundColor = UIColor.white
        view.addSubview(containerView)
        
        //containerview constraints 
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
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
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromiD).child(toID!)
                let messageID = messages_ref.key
                userMessagesRef.updateChildValues([messageID : 1])
                
                let receipientMessagesRef = Database.database().reference().child("user-messages").child(toID!).child(fromiD)
                receipientMessagesRef.updateChildValues([messageID: 1])
                
            })
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
