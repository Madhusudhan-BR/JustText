//
//  User.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/26/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import Foundation

class User : NSObject {
    private var _name: String!
    private var _email: String!
    private var _profileImageUrl: String!
    
    var profileImageUrl: String {
        get {return _profileImageUrl
        }
        set {
            _profileImageUrl = newValue
        }
    }
    
    
    var name: String {
        get {return _name
        }
        set {
            _name = newValue
        }
    }
    
    var email: String {
        
        get {
        return _email
        }
        set {
            _email = newValue
        }
    }
}
