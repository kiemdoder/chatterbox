//
//  SettingsTableViewController.swift
//  ChatterBox
//
//  Created by Roelf De Kock on 2018/08/19.
//  Copyright © 2018 Draadkar. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.prefersLargeTitles = true
  }

  @IBAction func logout(_ sender: UIButton) {
    FUser.logOutCurrentUser { success in
      if success {
        self.showLoginView()
      }
    }
  }

  func showLoginView() {
    let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
    present(mainView, animated: true, completion: nil)
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

}
