//
//  AppDelegate.swift
//  ChatterBox
//
//  Created by Roelf De Kock on 2018/08/02.
//  Copyright © 2018 Draadkar. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var authListener: AuthStateDidChangeListenerHandle?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    FirebaseApp.configure()
    
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    // Read dates like this:
    // let timestamp: Timestamp = documentSnapshot.get("created_at") as! Timestamp
    // let date: Date = timestamp.dateValue()
    
    //auto login
    authListener = Auth.auth().addStateDidChangeListener({ (auth, user) in
      Auth.auth().removeStateDidChangeListener(self.authListener!)
      if user != nil {
        if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
          DispatchQueue.main.async {
            self.goToApp()
          }
        }
      }
    })

    return true
  }

  func goToApp() {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION),
                                    object: nil,
                                    userInfo: [kUSERID: FUser.currentId()])

     let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
    window?.rootViewController = mainView
  }

}

