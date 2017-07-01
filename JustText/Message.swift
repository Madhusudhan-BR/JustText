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
    var toId : String?
    var fromId: String?
    var timestamp: Int?
    var text:String?
    var downloadUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    func chatPartnerId() -> String? {
        
        var chatPartnerId : String?
        if Auth.auth().currentUser?.uid == fromId {
            chatPartnerId = toId!
        }
        else {
            chatPartnerId = fromId!
        }
        
        return chatPartnerId
        
        
    }
    
     init(dictionary: [String: Any]) {
        super.init()
        
        toId = dictionary["toId"] as? String
        fromId = dictionary["fromId"] as? String
        timestamp = dictionary["timestamp"] as? Int
        text = dictionary["text"] as? String
        downloadUrl = dictionary["downloadUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        
        
    }
    
}
