//
//  UsersTableViewController.swift
//  ChatterBox
//
//  Created by Roelf De Kock on 2018/08/25.
//  Copyright © 2018 Draadkar. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class UsersTableViewController: UITableViewController, UISearchResultsUpdating {

  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var filterSegmentedControl: UISegmentedControl!

  var allUsers: [FUser] = []
  var filteredUsers: [FUser] = []
  var allUsersGrouped = [String: [FUser]]()
  var sectionTitleList = [String]()

  let searchController = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    super.viewDidLoad()

    loadUsers(filter: kCITY)
  }

  //MARK: - Search

  func loadUsers(filter: String) {
    ProgressHUD.show()

    var query: Query!

    switch filter {
    case kCITY:
      query = reference(.User).whereField(_: kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
    case kCOUNTRY:
      query = reference(.User).whereField(_: kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
    default:
      query = reference(.User).order(by: kFIRSTNAME, descending: false)
    }

    query.getDocuments { snapshot, err in
      self.allUsers = []
      self.sectionTitleList = []
      self.allUsersGrouped = [:]

      if let error = err {
        print(error.localizedDescription)
        ProgressHUD.dismiss()
        self.tableView.reloadData()
        return
      }

      guard let snapshot = snapshot else {
        ProgressHUD.dismiss()
        return
      }

      if !snapshot.isEmpty {
        for userDict in snapshot.documents {
          let userData = userDict.data() as NSDictionary
          let fUser = FUser(_dictionary: userData)

          if fUser.objectId != FUser.currentId() {
            self.allUsers.append(fUser)
          }
        }

        //split into groups
      }

      self.tableView.reloadData()
      ProgressHUD.dismiss()
    }
  }

  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredUsers = allUsers.filter { (user: FUser) -> Bool in
      return user.firstname.lowercased().contains(searchText)
    }
  }

  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchText: searchController.searchBar.text!)
  }

  // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return allUsers.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell

    cell.generateCellWith(fUser: allUsers[indexPath.row], indexPath: indexPath)

    return cell
  }

}
