//
//  Message.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/28/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import Foundation
import Firebase


class Message : NSObject {
    var _toId : String?
    var _fromId: String?
    var _timestamp: Int?
    var _text:String?
    
    func chatPartnerId() -> String? {
    
        var chatPartnerId : String?
    if Auth.auth().currentUser?.uid == _fromId {
    chatPartnerId = _toId!
    }
    else {
    chatPartnerId = _fromId!
    }
    
        return chatPartnerId
 
    
    }
}
