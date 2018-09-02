//
//  FinishRegistrationViewController.swift
//  ChatterBox
//
//  Created by Roelf De Kock on 2018/08/08.
//  Copyright © 2018 Draadkar. All rights reserved.
//

import UIKit
import ProgressHUD


class FinishRegistrationViewController: UIViewController {

  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var surnameTextField: UITextField!
  @IBOutlet weak var countryTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!

  var email: String!
  var password: String!
  var avatarImage: UIImage?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func dissmissKeyboard() {
    self.view.endEditing(false)
  }

  func cleanTextFields() {
    nameTextField.text = ""
    surnameTextField.text = ""
    countryTextField.text = ""
    cityTextField.text = ""
    phoneTextField.text = ""
  }

  func registerUser() {
    let fullName = nameTextField.text! + " " + surnameTextField.text!
    var user = [kFIRSTNAME: nameTextField.text!,
                kLASTNAME: surnameTextField.text!,
                kFULLNAME: fullName,
                kCOUNTRY: countryTextField.text!,
                kCITY: cityTextField.text!,
                kPHONE: phoneTextField.text!] as [String: Any]

    if avatarImage == nil {
      imageFromInitials(firstName: nameTextField.text!, lastName: surnameTextField.text!) { image in
        let avatarJPEGData = UIImageJPEGRepresentation(image, 0.7)
        let avatar = avatarJPEGData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        user[kAVATAR] = avatar

        self.finishRegistration(withValues: user)
      }
    } else {
      let avatarJPEGData = UIImageJPEGRepresentation(avatarImage!, 0.7)
      let avatar = avatarJPEGData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
      user[kAVATAR] = avatar

      self.finishRegistration(withValues: user)
    }
  }

  func finishRegistration(withValues: [String: Any]) {
    updateCurrentUserInFirestore(withValues: withValues) { err in
      if let error = err {
        DispatchQueue.main.async {
          ProgressHUD.showError(error.localizedDescription)
          print(error.localizedDescription)
        }

        return
      }

      ProgressHUD.dismiss()
      self.goToApp()
    }
  }

  func goToApp() {
    cleanTextFields()
    dissmissKeyboard()

    NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION),
                                    object: nil,
                                    userInfo: [kUSERID: FUser.currentId()])

    let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
    self.present(mainView, animated: true, completion: nil)
  }

  @IBAction func cancel() {
    dissmissKeyboard()
    cleanTextFields()
    dismiss(animated: true, completion: nil)
  }

  @IBAction func done() {
    dissmissKeyboard()
    ProgressHUD.show("Registering..")

    if nameTextField.text != "" &&
           surnameTextField.text != "" &&
           countryTextField.text != "" &&
           cityTextField.text != "" &&
           phoneTextField.text != "" {
      FUser.registerUserWith(email: email,
          password: password,
          firstName: nameTextField.text!,
          lastName: surnameTextField.text!) { error in
        if error != nil {
          ProgressHUD.dismiss()
          ProgressHUD.showError(error!.localizedDescription)
          return
        }

        self.registerUser()
      }
    } else {
      ProgressHUD.show("All fields are required")
    }
  }
  
  
}
