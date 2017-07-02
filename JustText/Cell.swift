//
//  Cell.swift
//  JustText
//
//  Created by Madhusudhan B.R on 6/28/17.
//  Copyright © 2017 Madhusudhan. All rights reserved.
//

import UIKit

class cell : UITableViewCell {
    
    
    
    let timeLabel : UILabel = {
        let time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        //time.text = "HH:MM::YY"
        time.font = UIFont.systemFont(ofSize: 12)
        time.textColor = UIColor.lightGray
        return time
    }()
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y:  (textLabel?.frame.origin.y)! + 2 , width: (textLabel?.frame.width)!, height : (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x : 64, y:  (detailTextLabel?.frame.origin.y)!+2, width : (detailTextLabel?.frame.width)!, height : (detailTextLabel?.frame.height)!)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        //anchors for profile image view
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        //anchors for timelabel 
        
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
