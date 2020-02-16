
//  LoginVC.swift
//  ride
//
//  Created by Darren Fuller.
//  Copyright © 2020 Darren Fuller. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, Alertable {
    
    @IBOutlet weak var emailField: RoundedCornerTextField!
    @IBOutlet weak var passwordField: RoundedCornerTextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var authBtn: RoundedShadowButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func authBtnWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField != nil {
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            if let email = emailField.text, let password = passwordField.text {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        if let result = user {
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                
                                let userData = ["provider": result.user.providerID] as [String: Any]
                                
                                DataService.instance.createFirebaseDBUser(uid: result.user.uid, userData: userData, isDriver: false)
                                
                            }else {
                                let userData = ["provider": result.user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverIsOnTrip": false] as [String: Any]
                                DataService.instance.createFirebaseDBUser(uid: result.user.uid, userData: userData, isDriver: true)
                            }
                        }

                        print("Email user authenticated successfully with Firebase")
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        
                        if let errorCode = AuthErrorCode(rawValue: error!._code){
                            switch errorCode {
                            case .wrongPassword:
                                self.showAlert("Whoops! That was the wrong password!")
                            default:
                                self.showAlert("An unexpected error occurred. Please try again")
                            }
                        }
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
        
                                if let errorCode = AuthErrorCode(rawValue: error!._code){
                                    switch errorCode {
                                    case .invalidEmail:
                                        self.showAlert("Email invalid. Please try again.")
                                    default:
                                        self.showAlert("An unexpected error occurred. Please try again")
                                    }
                                }
                                
                            } else {
                                if let result = user {
                                    if self.segmentedControl.selectedSegmentIndex == 0 {
                                        let userData = ["Provider": result.user.providerID] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: result.user.uid, userData: userData, isDriver: false)
                                        
                                    }else {
                                        let userData = ["provider": result.user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverIsOnTrip": false] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: result.user.uid, userData: userData, isDriver: true)
                                        
                                    }
                                }

                                print("Successfully created a new user with Firebase")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                        
                    }
                })
            }
        }
    }
}
