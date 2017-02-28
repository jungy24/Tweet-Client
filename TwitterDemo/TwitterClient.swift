//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Jungyoon Yu on 2/27/17.
//  Copyright © 2017 Jungyoon Yu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager
{
    
    
    static let sharedInstance = TwitterClient(
        baseURL: NSURL(string:"https://api.twitter.com")! as URL!,
        consumerKey: "i8OANvs9mndUfGjuGHKTw3KBg",
        consumerSecret: "htNPUCcCFSlWMn2tbyF5ZjQNipbSYGikeY8HOiqCJ17E1uuTpk")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ())
    {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth") as URL!, scope: nil, success: {(requestToken: BDBOAuth1Credential?) ->
            Void in
            print("got token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken!.token)!)")!
            UIApplication.shared.openURL(url as URL)
    
            
        })
        {(error: Error?) -> Void in
            print("error: \(error!.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    func logout()
    {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    
    func handleURL(url: URL)
    {
        let client = TwitterClient.sharedInstance
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken,
                         success:
            {
                (requestToken: BDBOAuth1Credential?) ->
                Void in
                
                self.currentAccount(
                    success: {  (user: User) in
                        User.currentUser = user
                        self.loginSuccess?()
                },
                    failure: { (error: Error) in
                        
                        self.loginFailure?(error)
                }
                )
                
        },
                         failure:
            {
                (error: Error?) -> Void in
                print("error: \(error!.localizedDescription)")
                self.loginFailure?(error!)
        }
            
            
        )
        
    }
    
    func homeTimeLine(success: @escaping ([Tweet]) ->(), failure: @escaping (Error)->())
    {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success:
            {
                (task: URLSessionDataTask, response: Any?) in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                
                success(tweets)
        },
            failure:
            {
                (task: URLSessionDataTask?, error: Error) in
                failure(error)
        }
        )
        
    }
    
    func currentAccount (success: @escaping (User) -> (), failure: @escaping (Error) -> () )
    {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success:
            {
                (task: URLSessionDataTask, response: Any?) in
                print("\(response)")
                let dictionaries = response as! NSDictionary
                let user = User(dictionary: dictionaries)
                
                success(user)
        },
            failure:
            {
                (task: URLSessionDataTask?, error: Error) in
                failure(error)
        }
        )
    }
    func retweet (id: Int )
    {
        print("1.1/statuses/retweet/\(id).json")
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil,
             success:
            {
                (task: URLSessionDataTask, response: Any?) in
                print("success")
        },
             failure:
            {
                (task: URLSessionDataTask?, error: Error) in
                print("fail")
        }
        )
    }
    func favorite(id: Int)
    {
        
        post("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil,
             success:
            {
                (task: URLSessionDataTask, response: Any?) in
                print("success")
        },
             failure:
            {
                (task: URLSessionDataTask?, error: Error) in
                print("fail")
        }
        )
        
    }
}
