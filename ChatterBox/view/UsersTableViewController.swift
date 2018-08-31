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

    title = "Users"
    navigationItem.largeTitleDisplayMode = .never

    //do not show the empty table cells for an empty table
    tableView.tableFooterView = UIView()

    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true

    loadUsers(filter: kCITY)
  }

  @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      loadUsers(filter: kCITY)
    case 1:
      loadUsers(filter: kCOUNTRY)
    case 2:
      loadUsers(filter: "")
    default:
      return
    }
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

        self.splitDataIntoSections()
        self.tableView.reloadData()
      }

      self.tableView.reloadData()
      ProgressHUD.dismiss()
    }
  }

  func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredUsers = allUsers.filter { (user: FUser) -> Bool in
      return user.fullname.lowercased().contains(searchText.lowercased())
    }
  }

  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchText: searchController.searchBar.text!)
    tableView.reloadData()
  }

  // MARK: - Table

  override func numberOfSections(in tableView: UITableView) -> Int {
    if searchController.isActive && searchController.searchBar.text != "" {
      return 1
    } else {
      return allUsersGrouped.count
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchController.isActive && searchController.searchBar.text != "" {
      return filteredUsers.count
    } else {
      let sectionTitle = sectionTitleList[section]
      let users = allUsersGrouped[sectionTitle]

      return users!.count
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell

    var user: FUser
    if searchController.isActive && searchController.searchBar.text != "" {
      user = filteredUsers[indexPath.row]
    } else {
      let sectionTitle = sectionTitleList[indexPath.section]
      let users = allUsersGrouped[sectionTitle]
      user = users![indexPath.row]
    }
    cell.generateCellWith(fUser: user, indexPath: indexPath)

    return cell
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if searchController.isActive && searchController.searchBar.text != "" {
      return ""
    } else {
      return sectionTitleList[section]
    }
  }
  
  override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    if searchController.isActive && searchController.searchBar.text != "" {
      return nil
    } else {
      return sectionTitleList
    }
  }
  
  override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return index
  }
  
  //MARK: - Helper functions

  fileprivate func splitDataIntoSections() {
    var sectionTitle = ""

    for i in 0..<allUsers.count {
      let currentUser = allUsers[i]
      let firstChar = currentUser.firstname.first!
      let firstCharStr = "\(firstChar)"
      if firstCharStr != sectionTitle {
        sectionTitle = firstCharStr
        allUsersGrouped[sectionTitle] = []
        sectionTitleList.append(sectionTitle)
      }
      
      allUsersGrouped[firstCharStr]?.append(currentUser)
    }
  }

}
