//
//  TweetDetailViewController.swift
//  TwitterDemo
//
//  Created by Jungyoon Yu on 3/6/17.
//  Copyright © 2017 Jungyoon Yu. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    
    @IBOutlet weak var userPic: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tweetmessage: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var faveCount: UILabel!
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var secondIcon: UIImageView!
    @IBOutlet weak var thirdIcon: UIImageView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let profPicURL = tweet?.profilePicUrl
        userPic.setImageWith(profPicURL!)
        
        username.text = tweet?.userName
        tweetmessage.text = tweet?.text
        retweetCount.text = "\(tweet?.retweetCount)"
        faveCount.text = "\(tweet?.favoritesCount)"
        
        if (tweet?.fav)!{
            firstIcon.image = #imageLiteral(resourceName: "favor-icon-red")
        } else {
            firstIcon.image = #imageLiteral(resourceName: "favor-icon")
        }
        if (tweet?.retweet)!{
            secondIcon.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else {
            secondIcon.image = #imageLiteral(resourceName: "retweet-icon")
        }
        thirdIcon.image = #imageLiteral(resourceName: "reply-icon")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
