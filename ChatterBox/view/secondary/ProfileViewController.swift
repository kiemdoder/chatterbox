//
//  ProfileViewController.swift
//  ChatterBox
//
//  Created by Roelf De Kock on 2018/08/31.
//  Copyright © 2018 Draadkar. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

  @IBOutlet weak var fullName: UILabel!
  @IBOutlet weak var phoneNumber: UILabel!
  @IBOutlet weak var messageButton: UIButton!
  @IBOutlet weak var phoneButton: UIButton!
  @IBOutlet weak var blockButton: UIButton!
  @IBOutlet weak var avatar: UIImageView!

  var user: FUser?

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }


  @IBAction func call(_ sender: Any) {
  }

  @IBAction func chat(_ sender: Any) {
  }

  @IBAction func blockUser(_ sender: Any) {
    var currentBlockedIDs = FUser.currentUser()!.blockedUsers
    if currentBlockedIDs.contains(user!.objectId) {
      currentBlockedIDs.remove(at: currentBlockedIDs.index(of: user!.objectId)!)
    } else {
      currentBlockedIDs.append(user!.objectId)
    }

    updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID: currentBlockedIDs]) { error in
      if let error = error {
        print("error updating user \(error)")
        return
      }

      self.updateBlockStatus()
    }
  }

  func setupUI() {
    if user != nil {
      title = "Profile"
      fullName.text = user!.fullname
      phoneNumber.text = user!.phoneNumber

      updateBlockStatus()

      imageFromData(pictureData: user!.avatar) { (avatarImage) in
        if let image = avatarImage {
          avatar.image = image.circleMasked
        }
      }
    }
  }

  func updateBlockStatus() {
    if user!.objectId != FUser.currentUser()?.objectId {
      blockButton.isHidden = false
      messageButton.isHidden = false
      phoneButton.isHidden = false
    } else {
      blockButton.isHidden = true
      messageButton.isHidden = true
      phoneButton.isHidden = true
    }

    if FUser.currentUser()!.blockedUsers.contains(user!.objectId) {
      blockButton.setTitle("Unblock User", for: .normal)
    } else {
      blockButton.setTitle("Block User", for: .normal)
    }
  }

  // MARK: - Table

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ""
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0
    }

    return 30
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
}
