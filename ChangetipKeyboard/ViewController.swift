//
//  ViewController.swift
//  ChangetipKeyboard
//
//  Created by Jack Cable on 11/25/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

class ViewController: UIViewController {
    
    //let scope = "create_tip_urls".urlEncode()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChangeKit.sharedInstance.clientID = "bHqTC61Fln8zpgmu8YlDGRm9hRPdHD8ynrh1fqaB"
        ChangeKit.sharedInstance.clientSecret = "iLkgb58FjIsQHuRpM9r6k1IP3xMD7mXZ9OdFsyazVh1WuUtqiErqrYdh0uRLv9wl1sgb4J4tdU4tHXUWrY2AdowOhHjQ66Y11yL7WfhC4XInYHVmIeG65syaQT2Mfr49"
        ChangeKit.sharedInstance.redirect_uri = "http://tiphound.me/callback.php?u=Jack-Cable.cable.ChangetipKeyboard"
        
        ChangeKit.sharedInstance.scope = ["create_tip_urls", "read_user_basic", "read_user_full"]
        
        /*changekit.createTipURL("$0.0001", message: "") { (response) -> Void in
            if let response = response {
                print(response["magic_url"])
            }
        }*/
        
        /*ChangeKit.sharedInstance.tipURL("$\(0.01)", message: "") { (response) -> Void in
            guard let response = response, let magic_url = response["magic_url"] else {
                print("error")
                return
            }
        }*/
        
        /*ChangeKit.sharedInstance.balance(ChangeKit.Currency.btc) { (response) -> Void in
            guard let response = response, let balance = response["balance_user_currency"] else {
                print("error")
                return
            }
            print(balance)
        }*/
        
        /*ChangeKit.sharedInstance.me(ChangeKit.Me.full) { (response) -> Void in
            guard let response = response else {
                print("Could not get information.")
                return
            }
            print(response)
        }*/
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func authenticate(sender: AnyObject) {
        ChangeKitAuthenticate.sharedInstance.authenticate()
    }

}

