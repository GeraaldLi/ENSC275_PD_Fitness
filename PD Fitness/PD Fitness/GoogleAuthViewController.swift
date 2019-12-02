//
//  GoogleAuthViewController.swift
//  PD Fitness
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs:
//  1) userIDLable doesn't get update after user login
//  2) google connection prompts upon loading controll view for the first time
//
// TODO:
// 1) Change Database layout such that it supports storing user info
// 2) Fix known bugs


import UIKit
import Firebase
import GoogleSignIn

class GoogleAuthViewController: UIViewController, GIDSignInDelegate {
    
    // Google SignIn button
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    // User lable
    @IBOutlet weak var userIDLable: UILabel?
        
    // User ID default to Guest
    var userID: String = "Guest"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google Login
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //Initialize lable text
        updateLableText()
        
        //Configure the sign-in button look
        googleSignInButton.style = .wide
    }
    
    //Update User and Lable Text upon view showing
    override func viewWillAppear(_ animated: Bool) {
        updateUser()
        updateLableText()
    }
        
    //###################################### Supporting Functions ######################################
    //Update userID
    func updateUser()
    {
        // Update User object
        if GIDSignIn.sharedInstance()!.currentUser != nil {
            let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
            self.userID = user.profile.name
        }
        else
        {
            self.userID = "Guest"
        }
    }
    
    //Update Lable Texts
    func updateLableText()
    {
        userIDLable?.text = "User : " + userID
    }
    
    //Set up goolge Sign In Feature
    //support IOS 9.0 and latter, URL handller
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    //Login Functions
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
      if error != nil {
        return
      }
        
      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      
      //Update Tracking Login Page
      viewWillAppear(false)
      
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if error != nil {
          return
        }
      }
    }
    
    //Optional for set up
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}
