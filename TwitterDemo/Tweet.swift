//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Jungyoon Yu on 2/27/17.
//  Copyright © 2017 Jungyoon Yu. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var userName: String?
    var profilePicUrl: URL?
    var id: Int?
    var retweet: Bool?
    var fav: Bool?
    
    
    init(dictionary: NSDictionary)
    {
        print("\(dictionary)")
        text = dictionary["text"] as? String
        
        let user = dictionary["user"] as? NSDictionary
        userName = user?["name"]as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as?  String
        
        
        if let timeStampString = timeStampString
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timeStampString)
            
        }
        let imageURL = user?["profile_image_url_https"] as? String
        profilePicUrl = URL(string: imageURL! )
        
        id = dictionary["id"] as? Int
        
        
        
        
        self.retweet = dictionary["retweeted"] as? Bool
        self.fav = dictionary["favorited"] as? Bool
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]
    {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries
        {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
        
    }
    
}
