//
//  WelcomeViewController.swift
//  ChatterBox
//
//  Created by Roelf De Kock on 2018/08/02.
//  Copyright © 2018 Draadkar. All rights reserved.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {

  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var repeatPassword: UITextField!
  
  override func viewDidLoad() {
        super.viewDidLoad()

    }
  
  @IBAction func login(_ sender: Any) {
    dismissKeyboard()
    if email.text != "" && password.text != "" {
      loginUser()
    } else {
      ProgressHUD.showError("Email and Password is missing")
    }
  }
  
  @IBAction func register(_ sender: Any) {
    dismissKeyboard()

    if email.text != "" && password.text != "" && repeatPassword.text != "" {
      if password.text == repeatPassword.text {
        registerUser()
      } else {
        ProgressHUD.showError("Passwords does not match")
      }
    } else {
      ProgressHUD.showError("All fields are required")
    }
  }
  
  @IBAction func backgroundTap(_ sender: Any) {
    dismissKeyboard()
  }
  
  func loginUser() {
    ProgressHUD.show("Login...")
    
    FUser.loginUserWith(email: email.text!, password: password.text!) { error in
      if let err = error {
        ProgressHUD.showError(err.localizedDescription)
        return
      }
      
      //present the app
      self.goToApp()
    }
  }
  
  func registerUser() {
    performSegue(withIdentifier: "finishRegistration", sender: self)
    cleanTextFields()
    dismissKeyboard()
  }
  
  func dismissKeyboard() {
    self.view.endEditing(false)
  }
  
  func cleanTextFields() {
    email.text = ""
    password.text = ""
    repeatPassword.text = ""
  }

  //MARK: - GoToApp

  func goToApp() {
    ProgressHUD.dismiss()
    cleanTextFields()
    dismissKeyboard()

    NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION),
                                    object: nil,
                                    userInfo: [kUSERID: FUser.currentId()])

    let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
    self.present(mainView, animated: true, completion: nil)
  }
  
  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "finishRegistration" {
      let vc = segue.destination as! FinishRegistrationViewController
      vc.email = email.text!
      vc.password = password.text!
    }
  }
}
