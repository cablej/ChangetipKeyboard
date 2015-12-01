//
//  ViewController.swift
//  ChangetipKeyboard
//
//  Created by Jack Cable on 11/25/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

extension String { //helper method for oauth
    public func urlEncode() -> String {
        let encodedURL = CFURLCreateStringByAddingPercentEscapes(
            nil,
            self as NSString,
            nil,
            "!@#$%&*'();:=+,/?[]",
            CFStringBuiltInEncodings.UTF8.rawValue)
        return encodedURL as String
    }
}

import UIKit
import MobileCoreServices
import AssetsLibrary

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    var accessToken = ""
    
    let clientID = "bHqTC61Fln8zpgmu8YlDGRm9hRPdHD8ynrh1fqaB"
    let clientSecret = "iLkgb58FjIsQHuRpM9r6k1IP3xMD7mXZ9OdFsyazVh1WuUtqiErqrYdh0uRLv9wl1sgb4J4tdU4tHXUWrY2AdowOhHjQ66Y11yL7WfhC4XInYHVmIeG65syaQT2Mfr49"
    
    let baseURL = NSURL(string: "https://www.changetip.com/")
    let scope = "create_tip_urls".urlEncode()
    let redirect_uri = "http://tiphound.me/callback.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.becomeFirstResponder()
    }
    
    func parametersFromQueryString(queryString: String?) -> [String: String] { //helper method for oauth
        var parameters = [String: String]()
        if (queryString != nil) {
            var parameterScanner: NSScanner = NSScanner(string: queryString!)
            var name:NSString? = nil
            var value:NSString? = nil
            while (parameterScanner.atEnd != true) {
                name = nil;
                parameterScanner.scanUpToString("=", intoString: &name)
                parameterScanner.scanString("=", intoString:nil)
                value = nil
                parameterScanner.scanUpToString("&", intoString:&value)
                parameterScanner.scanString("&", intoString:nil)
                if (name != nil && value != nil) {
                    parameters[name!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!]
                        = value!.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                }
            }
        }
        return parameters
    }
    
    var isObserved = false
    @IBAction func authenticate(sender: AnyObject) {
        // 1 Replace with client id /secret
        
        if !isObserved {
            // 2 Add observer
            var applicationLaunchNotificationObserver = NSNotificationCenter.defaultCenter().addObserverForName(
                "AGAppLaunchedWithURLNotification",
                object: nil,
                queue: nil,
                usingBlock: { (notification: NSNotification!) -> Void in
                    // [5] extract code
                    let code = self.extractCode(notification)
                    
                    // [6] carry on oauth2 code auth grant flow with AFOAuth2Manager
                    let manager = AFOAuth2Manager(baseURL: self.baseURL,
                        clientID: self.clientID,
                        secret: self.clientSecret)
                    manager.useHTTPBasicAuthentication = false
                    
                    // [7] exchange authorization code for access token
                    manager.authenticateUsingOAuthWithURLString("o/token/",
                        code: code,
                        redirectURI: self.redirect_uri,
                        success: { (cred: AFOAuthCredential!) -> Void in
                            
                            
                            self.accessToken = cred.accessToken
                            
                            NSUserDefaults.standardUserDefaults().setObject(self.accessToken, forKey: "accessToken")
                            
                        }) { (error: NSError!) -> Void in
                            self.presentAlert("Error", message: error!.localizedDescription)
                    }
            })
            isObserved = true
        }
        
        // 3 calculate final url
        var params = "?scope=\(scope)&redirect_uri=\(redirect_uri)&client_id=\(clientID)&response_type=code"
        // 4 open an external browser
        UIApplication.sharedApplication().openURL(NSURL(string: "https://changetip.com/o/authorize/\(params)")!)
    }
    
    @IBAction func sendTip(sender: AnyObject) {
        
    }
    
    func extractCode(notification: NSNotification) -> String? {
        let url: NSURL? = (notification.userInfo as!
            [String: AnyObject])[UIApplicationLaunchOptionsURLKey] as? NSURL
        
        // [1] extract the code from the URL
        return self.parametersFromQueryString(url?.query)["code"]
    }
    
    func presentAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

