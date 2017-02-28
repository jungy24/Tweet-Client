//
//  User.swift
//  TwitterDemo
//
//  Created by Jungyoon Yu on 2/27/17.
//  Copyright © 2017 Jungyoon Yu. All rights reserved.
//

import UIKit

class User: NSObject {

    static let userDidLogoutNotification = "UserDidLogout"
    var name: String?
    var screenname: String?
    var profileURL: URL?
    var tagline: String?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary)
    {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let url = dictionary["profile_image_url_https"] as? String
        
        if let url = url
        {
            profileURL = URL(string: url)
        }
        
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    
    class var currentUser: User?
        {
        get
        {
            if (_currentUser == nil)
            {
                
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                
                if let userData = userData
                {
                    if let dic = try? JSONSerialization.jsonObject(with: userData,options: [])
                    {
                        let dictionary = dic as! NSDictionary
                        _currentUser = User(dictionary: dictionary)
                    }
                    
                    
                }
            }
            
            return _currentUser
        }
        set(user)
        {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user
            {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            }
            else
            {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
        
    }
    
}
