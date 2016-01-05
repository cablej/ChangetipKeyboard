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

class KeyboardViewController: UIInputViewController {
    
    var changetipView: UIView!
    let keychain = Keychain()
    
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
        ChangeKit.sharedInstance.tipURL("$\(amount)", message: "") { (dictionary) -> Void in
            guard let dictionary = dictionary, let magic_url = dictionary["magic_url"] else {
                self.amountLabel.text = "Error"
                return
            }
            self.textDocumentProxy.insertText(magic_url as! String)
        }
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
    

}
