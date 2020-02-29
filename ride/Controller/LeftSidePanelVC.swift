
//  LeftSidePanelVC.swift
//  ride
//
//  Created by Darren Fuller.
//  Copyright © 2020 Darren Fuller. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userAccountType: UILabel!
    @IBOutlet weak var userImageView: RoundImageView!
    @IBOutlet weak var loginOutBtn: UIButton!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    @IBOutlet weak var pickupModeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickupModeSwitch.isOn = false
        pickupModeLbl.text = "PICKUP MODE DISABLED"
        pickupModeSwitch.isHidden = true
        pickupModeLbl.isHidden = true
        
        observePassengersAndDrivers()
        
        if Auth.auth().currentUser == nil {
            userEmailLbl.text = ""
            userAccountType.text = ""
            userImageView.isHidden = true
            
            loginOutBtn.setTitle("Sign UP / Login", for: .normal)
            
        } else {
            userEmailLbl.text = Auth.auth().currentUser?.email
            
            userAccountType.text = ""
            userImageView.isHidden = false
                   
            loginOutBtn.setTitle("Logout", for: .normal)
            
        }
    }

    
    func observePassengersAndDrivers() {

        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if snap.key == Auth.auth().currentUser?.uid {
                    self.userAccountType.text = "PASSENGER"
                    }
                }
            }
        })
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot{
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountType.text = "DRIVER"
                    
                        self.pickupModeSwitch.isHidden = false
                        
                        let switchStatus = snap.childSnapshot(forPath: "isPickupModeEnabled").value as! Bool

                        self.pickupModeSwitch.isOn = switchStatus
                        self.pickupModeLbl.isHidden = false
                        
                    }
                }
            }
        })
    }
    

    
    @IBAction func switchWasToggled(_ sender: Any) {

        if pickupModeSwitch.isOn {

            pickupModeLbl.text = "PICKUP MODE ENABLED"
            
            appDelegate.MenuContainerVC.toggleLeftPanel()
            if ((currentUserId != nil)) {
                DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled": true])
            }
            
            
        } else {
            pickupModeLbl.text = "PICKUP MODE DISABLED"
            
            appDelegate.MenuContainerVC.toggleLeftPanel()
            if ((currentUserId != nil)) {
                DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled": false])
            }
        }
        
    }
    
    
    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        if Auth.auth().currentUser == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
            
        } else {
            do {
                try Auth.auth().signOut()

                userEmailLbl.text = ""
                userAccountType.text = ""
                userImageView.isHidden = true
                pickupModeLbl.text = ""
                pickupModeSwitch.isHidden = true

                loginOutBtn.setTitle("Sign up / Login", for: .normal)

            } catch (let error) {
                print(error)
            }
        }
        
    }
}
