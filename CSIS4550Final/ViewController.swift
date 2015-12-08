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
	//Login page fields
	@IBOutlet weak var loginUsernameField: UITextField!
	@IBOutlet weak var loginPasswordField: UITextField!
	//Signup page fields
	@IBOutlet weak var usernameField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var confirmPasswordField: UITextField!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var phoneField: UITextField!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//setup tap recognizer to hide keyboard when done editing.
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		view.addGestureRecognizer(tap)
	}
	
	//The keyboard doesn't automatically dissapear when you tap outside the text field, so this is a simple function to fix that.
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func loginAction(sender: AnyObject){
		let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
		spinner.startAnimating()
		
		PFUser.logInWithUsernameInBackground(self.loginUsernameField.text!, password: self.loginPasswordField.text!, block: { (user, error) -> Void in
			spinner.stopAnimating()
			if(user != nil) {
				self.showAlertController("Logged In")
				
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Success")
					self.presentViewController(viewController, animated: true, completion: nil)
				})
			} else {
				self.showAlertController("\(error)")
			}
		})
	}
	
	@IBAction func signUpAction(sender: AnyObject){
		//Check if the passwords match before creating user
		if(self.passwordField.text != self.confirmPasswordField.text){
			self.showAlertController("Passwords do not match.")
		} else{
			//lets create a spinner to show the user it is loading
			let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
			spinner.startAnimating()
			
			//create a user object
			let newUser = PFUser()
			
			newUser.username = self.usernameField.text
			newUser.password = self.passwordField.text
			newUser.email = self.emailField.text
			//Custom field, not part of PFUser
			newUser["phone"] = self.phoneField.text
			
			//The actual connection to the database
			newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
			spinner.stopAnimating()
				if((error) != nil) {
					self.showAlertController("\(error)")
				} else {
					self.showAlertController("Signed Up")
					//Now that it was a success we are going to switch views
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") 
						self.presentViewController(viewController, animated: true, completion: nil)
					})
				}
			})
		}
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
						self.navigateToAuthenticatedViewController()
					}
					else {
						self.showAlertController("Touch ID Authentication Failed")
					}
			})
		}
		else  {
			showAlertController("Touch ID not available")
		}
	}
	
	func navigateToAuthenticatedViewController() {
		if let loggedInVC = storyboard?.instantiateViewControllerWithIdentifier("Success") {
			dispatch_async(dispatch_get_main_queue()) { () -> Void in
				self.navigationController?.pushViewController(loggedInVC, animated: true)
			}
		}
	}
	
	/*func storeUserLogin(){
	SignUp.toPass = textField.txt
	}
	*/
}