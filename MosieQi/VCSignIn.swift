//
//  VCSignIn.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/09/2022.
//

import UIKit

import GoogleAPIClientForREST
import GoogleSignIn
import UIKit
// import GoogleSignIn module

class ViewController: UIViewController {
    
    var signInButton: UIButton!
    var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add greeting label
        greetingLabel = UILabel()
        greetingLabel.text = "Please sign in... 🙂"
        greetingLabel.textAlignment = .center
        greetingLabel.backgroundColor = .tertiarySystemFill
        view.addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        greetingLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
        greetingLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        // Add sign-in button
        signInButton = UIButton()
        signInButton.layer.cornerRadius = 10.0
        signInButton.setTitle("Sign in with Google", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .systemRed
        signInButton.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        signInButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        // Let GIDSignIn know that this view controller is presenter of the sign-in sheet
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Register notification to update screen after user successfully signed in
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidSignInGoogle(_:)),
                                               name: .signInGoogleCompleted,
                                               object: nil)
        
        
    }
    // MARK:- Button action
    @objc func signInButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    // MARK:- Notification
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        // Update screen after user successfully signed in
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavHome") as! NCHome
        
    }
}
