//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Jungyoon Yu on 2/27/17.
//  Copyright © 2017 Jungyoon Yu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let client = TwitterClient.sharedInstance
        client?.login(
            success:
            {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
        },
            failure:
            { (error: Error) in
                print("Error: \(error)")
        }
        )
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
