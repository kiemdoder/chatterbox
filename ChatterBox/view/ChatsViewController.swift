//
//  ChatsViewController.swift
//  ChatterBox
//
//  Created by Roelf De Kock on 2018/08/27.
//  Copyright © 2018 Draadkar. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.prefersLargeTitles = true
  }

  @IBAction func createNewChat(_ sender: Any) {
    let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userTableView") as! UsersTableViewController
    navigationController?.pushViewController(userVC, animated: true)
  }
}
