//
//  AppDelegate.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/08/2022.
//

import UIKit
import GoogleSignIn
import AVFoundation
import GoogleAPIClientForREST

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Google sign-in.
        GIDSignIn.sharedInstance().clientID = "1094171447399-npkqnpdok8q1mubp0lhd5oi8mspl288t.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self
        let scopes = [kGTLRAuthScopeYouTubeReadonly]
        GIDSignIn.sharedInstance().scopes = scopes
        if GIDSignIn.sharedInstance().hasPreviousSignIn(){
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        return true
    }
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
extension AppDelegate: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!,
              didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        let service = GTLRYouTubeService()
        
        if let error = error {
            service.authorizer = nil
            print("Login Error: \(error.localizedDescription)")
        } else {
            service.authorizer = user.authentication.fetcherAuthorizer()
            let access_token = user.authentication.accessToken
            if let accessToken = access_token{
                //to-do: Save in KeyChain
                AuthServices.shared.token = accessToken
                AuthServices.shared.isLoggedIn = true
            }
            print("saved access_token ", AuthServices.shared.token )
        }

        // Post notification after user successfully sign in
        NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
    }
}
// MARK:- Notification names
extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
