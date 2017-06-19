//
//  LoginVC.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/19/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
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
        button.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
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
    
    let profileImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Group")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 244/255, green: 167/255, blue: 35/255, alpha: 1)
        
        
        view.addSubview(inputContainerView)
        view.addSubview(resgisterButton)
        view.addSubview(profileImage)
        // x y width and height constraints 
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputContainerView.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12 ).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainerView.addSubview(nameSeperatorView)
        nameSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12 ).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainerView.addSubview(emailSeperatorView)
        emailSeperatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        inputContainerView.addSubview(passwordTextField)
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor , constant: 12 ).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.topAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true

        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -24).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        setupRegisterButton()
        
    }
    
    func registerButtonPressed() {
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            print("MADHU: Invalid data! ")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
          
            if error != nil {
                print("MADHU : \(error.debugDescription)")
                return
            }
            
            // user successgully authenticated 
            
            let values = ["name" : name, "email" : email]
            let ref_individualUsers = ref_users.child((user?.uid)!)
            
            ref_individualUsers.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print("MADHU: Error while updating users on DB \(err.debugDescription)")
                        return
                }
                
                print("MADHU: Saved users successfully to DB")
            })
            
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
    

}
