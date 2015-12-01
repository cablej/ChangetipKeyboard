//
//  KeyboardViewController.swift
//  Changetip
//
//  Created by Jack Cable on 11/25/15.
//  Copyright © 2015 Jack Cable. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

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

class KeyboardViewController: UIInputViewController {

    var changetipView: UIView!
    let clientID = "bHqTC61Fln8zpgmu8YlDGRm9hRPdHD8ynrh1fqaB"
    let clientSecret = "iLkgb58FjIsQHuRpM9r6k1IP3xMD7mXZ9OdFsyazVh1WuUtqiErqrYdh0uRLv9wl1sgb4J4tdU4tHXUWrY2AdowOhHjQ66Y11yL7WfhC4XInYHVmIeG65syaQT2Mfr49"
    
    let baseURL = NSURL(string: "https://www.changetip.com/")
    let scope = "create_tip_urls".urlEncode()
    let redirect_uri = "http://tiphound.me/callback.php"

    @IBOutlet var amountLabel: UILabel!
    
    @IBOutlet var numberButtons: [AnyObject]!
    var amount = ""
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        // Add custom view sizing constraints here
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInterface()
        
        for button in numberButtons {
            let layer: CALayer = button.layer;
            layer.backgroundColor = UIColor(red: 9/255.0, green: 58/255.0, blue: 98/255.0, alpha: 0.95).CGColor
            //layer.borderColor = UIColor.darkGrayColor().CGColor
            layer.cornerRadius = 8.0
            //layer.borderWidth = 1.0
        }
<<<<<<< HEAD
        
        
=======
>>>>>>> origin/master
    }
    
    func loadInterface() {
        // load the nib file
        let calculatorNib = UINib(nibName: "Changetip", bundle: nil)
        // instantiate the view
        changetipView = calculatorNib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        // add the interface to the main view
        view.addSubview(changetipView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    @IBAction func onTipButtonTapped(sender: AnyObject) {
<<<<<<< HEAD
        //let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("accessToken")!
        let userDefaults = NSUserDefaults(suiteName: "group.ChangetipKeyboard")
        userDefaults?.synchronize()
        
        let accessToken = userDefaults?.objectForKey("accessToken") as! String
        
        print("sending tip: \(accessToken)")
        // [8] Set credential in header
        
        
        let url = NSURL(string: "https://www.changetip.com/v2/tip-url/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.HTTPBody = "amount=$\(amount)".dataUsingEncoding(NSUTF8StringEncoding)
        //self.amountLabel.text = "\(accessToken)"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            guard let JSONdata = data else {
                self.amountLabel.text = "Error 1"
                return
            }
            var JSON: NSDictionary?
            do {
                JSON = try NSJSONSerialization.JSONObjectWithData(JSONdata, options: []) as! NSDictionary
            } catch {
                self.amountLabel.text = "Error 2"
            }
            if let json = JSON {
                guard let url = json["magic_url"] as? NSString else {
                    print("cannot parse url")
                    self.amountLabel.text = "Error 3"
                    return
                }
                self.textDocumentProxy.insertText(url as String)
            }
            self.amountLabel.text = "Tip url created!"
            self.amount = ""
        }
        
        //self.textDocumentProxy.insertText("http://tip.me/once/6dtE-yXy5N9f")
        
=======
        
        let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("accessToken")
        
        print("sending tip: \(accessToken)")
        // [8] Set credential in header
        let manager = AFOAuth2Manager(baseURL: self.baseURL,
            clientID: self.clientID,
            secret: self.clientSecret)
        manager.useHTTPBasicAuthentication = false
        print(accessToken)
        manager.requestSerializer.setValue("Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization")
        manager.POST("https://www.changetip.com/v2/tip-url/",
            parameters: ["amount" : "1 satoshi"], success: { (op:AFHTTPRequestOperation!, obj:AnyObject!) -> Void in
                let url = obj["magic_url"]! as! NSString
                self.presentAlert("Success", message: "Successfully uploaded to \(url)")
            }, failure: { (op: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.presentAlert("Error", message: error!.localizedDescription)
        })
        
        self.textDocumentProxy.insertText("http://tip.me/once/6dtE-yXy5N9f")
>>>>>>> origin/master
    }
    
    func presentAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSpaceButtonTapped(sender: AnyObject) {
        self.textDocumentProxy.insertText(" ")
    }
    
    @IBAction func onDeleteTextButtonTapped(sender: AnyObject) {
        self.textDocumentProxy.deleteBackward()
    }
    
    @IBAction func onNextKeyboardTapped(sender: AnyObject) {
        self.advanceToNextInputMode()
    }
    
    @IBAction func onNumberButtonTapped(sender: UIButton) {
        amount += sender.titleLabel!.text!
        amountLabel.text = "$\(amount)"
    }
    
    @IBAction func onDeleteButtonTapped(sender: AnyObject) {
        amount = String(amount.characters.dropLast())
        amountLabel.text = "$\(amount)"
    }
    
    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        /*var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)*/
    }

}
