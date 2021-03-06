//
//  LoginVC.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/19/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class LoginVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var mainVC = MainVC()
    
    let inputContainerView: UIView = {
        //let view = UIView()
        
        let inputContainerView = UIView()
        inputContainerView.backgroundColor = UIColor.white
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.layer.cornerRadius = 5
        inputContainerView.layer.masksToBounds = true
        
        return inputContainerView
    }()
    
    let resgisterButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Register", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor(red: 244/255, green: 167/255, blue: 35/255, alpha: 1), for: .normal )
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        return button
    }()
    
    
    
    let nameTextField : UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let nameSeperatorView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()
    
    let emailTextField : UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    let emailSeperatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
        
    }()

    let passwordTextField : UITextField = {
        
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    
    lazy var profileImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "addpic")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped)))
        img.isUserInteractionEnabled = true
        img.alpha = 0.8
        return img
    }()
    
    func handleProfileImageTapped() {
        
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
            profileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    let loginRegisterSegmentedControl : UISegmentedControl  = {
        let sc = UISegmentedControl(items: ["Login ", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterSegControl), for: .valueChanged)
        return sc
    }()
    
    var inputContainerViewHeightConstraint: NSLayoutConstraint?
    var nameTextFieldHeightConstraint: NSLayoutConstraint?
    var emailTextFieldHeightConstraint: NSLayoutConstraint?
    var passwordTextFieldHeightConstraint: NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 244/255, green: 167/255, blue: 35/255, alpha: 1)
        
        
        view.addSubview(inputContainerView)
        view.addSubview(resgisterButton)
        view.addSubview(profileImage)
        view.addSubview(loginRegisterSegmentedControl)

        // x y width and height constraints 
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        inputContainerViewHeightConstraint = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightConstraint?.isActive = true
        
        
        
        inputContainerView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12 ).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        //nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        nameTextFieldHeightConstraint?.isActive  = true
        
        inputContainerView.addSubview(nameSeperatorView)
        nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12 ).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        //emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightConstraint?.isActive=true
        
        inputContainerView.addSubview(emailSeperatorView)
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        inputContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12 ).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
       // passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightConstraint?.isActive=true
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -24).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 120  ).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        
        setupRegisterButton()
        setupLoginRegisterSegmentedControl()
                
    }
    
    func askForNotificationPermission() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound , .badge]) { (granted, error) in
            if granted {
                print("permission granted")
                
            }
            else {
                print("request denied")
            }
        }
        
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -12).isActive = true

        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true

        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true

    }
    
    func handleLoginRegisterSegControl()
    {
        resgisterButton.setTitle(loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex), for: .normal)
        
        inputContainerViewHeightConstraint?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightConstraint?.isActive = false
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightConstraint?.isActive = true
        
        
        emailTextFieldHeightConstraint?.isActive = false
        emailTextFieldHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightConstraint?.isActive = true
        
        
        
        passwordTextFieldHeightConstraint?.isActive = false
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightConstraint?.isActive = true
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            nameTextField.isHidden = true
        } else {
            nameTextField.isHidden = false 
        }
        
    }
    
    func handleRegisterLogin() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            registerButtonPressed()
        }
    }
    
    func handleLogin() {
        
        guard  let email = emailTextField.text, let password = passwordTextField.text else {
            print("MADHU: Invalid data! ")
             self.createAlert(title: "Error", message: "Invalid Data")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            
            if error != nil {
                print(error)
                self.createAlert(title: "Error", message: (error?.localizedDescription)!)
                return 
            }
            
            print("MADHU: \(user?.uid)")
            self.mainVC.handleLoggedInUser()
            self.dismiss(animated: true, completion: nil )
            
        }
        
        
    }
    
    
    func registerButtonPressed() {
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("MADHU: Invalid data! ")
            self.createAlert(title: "Error", message: "Invalid Data")

           return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
          
            if error != nil {
                print("MADHU : \(error.debugDescription)")
                self.createAlert(title: "Error", message: (error?.localizedDescription)!)

                return
            }
            
            // user successgully authenticated 
            
           self.askForNotificationPermission()
            
            let storage_ref = Storage.storage().reference().child("profileImages").child("\(user?.uid)")
            if let profileImageJpeg = UIImageJPEGRepresentation(self.profileImage.image!, 0.1){
                
            storage_ref.putData(profileImageJpeg, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let profileImageDownloadUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name" : name, "email" : email, "profileImageUrl" : profileImageDownloadUrl]
                        let ref_individualUsers = ref_users.child((user?.uid)!)
                        
                        ref_individualUsers.updateChildValues(values, withCompletionBlock: { (err, ref) in
                            
                            if err != nil {
                                print("MADHU: Error while updating users on DB \(err.debugDescription)")
                                return
                            }
                            
                            print("MADHU: Saved users successfully to DB")
                            self.mainVC.handleLoggedInUser()
                            self.dismiss(animated: true, completion: nil)
                        })

                        
                        
                    }
                    
                    
                })

                
            }
            
            
            
            
            
            
            
        }
        
        
    }
    
    func setupRegisterButton(){
        
        
        resgisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resgisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        resgisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        resgisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

}
