//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Jungyoon Yu on 2/27/17.
//  Copyright © 2017 Jungyoon Yu. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        TwitterClient.sharedInstance?.homeTimeLine(
            
            success:
            { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
        },
            failure:
            { ( error: Error) in
                print("Error: \(error.localizedDescription)")
        }
        )
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let tweets = tweets
        {
            return tweets.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.selectionStyle = .none
        
        let tweet = tweets[indexPath.row]
        
        cell.userName.text = tweet.userName
        cell.tweetText.text = tweet.text
        cell.timeStamp.text = ("\(tweet.timestamp!)")
        cell.profilePic.setImageWith(tweet.profilePicUrl!)
        cell.retweetCount.text = ("\(tweet.retweetCount)")
        
        cell.favorCount.text = ("\(tweet.favoritesCount)")
        
        if(tweet.retweet! == true)
        {
            cell.retweetButton.setImage(UIImage(named: "retweet-icon-green.png"), for: UIControlState.normal)
        }
        else
        {
            cell.retweetButton.setImage(UIImage(named: "retweet-icon.png"), for: UIControlState.normal)
        }
        
        
        if(tweet.fav! == true)
        {
            cell.favButton.setImage(UIImage(named: "favor-icon-red.png"), for: UIControlState.normal)
        }
        else
        {
            cell.favButton.setImage(UIImage(named: "favor-icon.png"), for: UIControlState.normal)
        }
        
        return cell
    }
    
    @IBAction func retweetChange(_ sender: Any) {
        var indexPath = tableView.indexPath(for: (sender as! UIButton).superview?.superview as! UITableViewCell)
        let tweet = tweets[(indexPath?.row)!]
        TwitterClient.sharedInstance?.retweet(id: tweet.id!)
        let cell = (sender as! UIButton).superview?.superview as! TweetCell
        sleep(UInt32(1))
        
        TwitterClient.sharedInstance?.homeTimeLine(
            
            success:
            { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
        },
            failure:
            { ( error: Error) in
                print("error: \(error.localizedDescription)")
        }
        )
        cell.retweetButton.setImage(UIImage(named: "retweet-icon-green.png"), for: UIControlState.normal)
        
        tweet.retweet = true;
        
        tableView.reloadData()
    }
    
    @IBAction func favorChange(_ sender: Any) {
        var indexPath = tableView.indexPath(for: (sender as! UIButton).superview?.superview as! UITableViewCell)
        let tweet = tweets[(indexPath?.row)!]
        TwitterClient.sharedInstance?.favorite(id: tweet.id!)
        
        sleep(UInt32(1))
        
        TwitterClient.sharedInstance?.homeTimeLine(
            
            success:
            { (tweets: [Tweet]) in
                self.tweets = tweets
                self.tableView.reloadData()
        },
            failure:
            { ( error: Error) in
                print("error: \(error.localizedDescription)")
        }
        )
        tweet.fav = true;
        
        self.tableView.reloadData()
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
        // Pass the selected object to the new view controller.
        let cell = sender as? UITableViewCell
        let loc = tableView.indexPath(for: cell!)
        let tweeter = self.tweets![loc!.row]
        let detailedTweetViewController = segue.destination as! TweetDetailViewController
        detailedTweetViewController.tweet = tweeter
    }
    

}
