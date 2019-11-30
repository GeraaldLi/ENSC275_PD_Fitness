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

class GoogleAuthViewController: UIViewController {
    
    // Google SignIn button
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    // User lable
    @IBOutlet weak var userIDLable: UILabel?
    
    // User ID default to Guest
    var userID: String = "Guest"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Google Login
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        //Initialize lable text
        updateLableText()
        
        //Configure the sign-in button look
        googleSignInButton.style = .wide
    }
    
    func updateUser()
    {
        // Update User object
        let user: GIDGoogleUser = GIDSignIn.sharedInstance()!.currentUser
        self.userID = user.profile.name
        // Update lable text
        //updateLableText()
    }
    
    func updateLableText()
    {
        userIDLable?.text = "User : " + userID
    }
}
