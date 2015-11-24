//
//  ViewController.swift
//  CSIS4550Final
//
//  Created by Sean Robinson on 11/17/15.
//  Copyright © 2015 Sean Robinson. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAlertController(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        }

    @IBAction func authenticateWithTouchID(sender: AnyObject) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            let reason = "Please authenticate to proceed."
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                    {(success: Bool, error: NSError?) in
                    if success {
                        self.showAlertController("Touch ID Authentication Succeeded")
                    }
                    else {
                        self.showAlertController("Touch  ID Authentication Failed")
                    }
                })
        }
        else  {
            showAlertController("Touch ID not available")
        }
    }
}

