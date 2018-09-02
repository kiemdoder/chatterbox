//
//  UserCell.swift
//  ChatterBox
//
//  Created by Roelf De Kock on 2018/08/21.
//  Copyright © 2018 Draadkar. All rights reserved.
//

import UIKit

protocol UserCellDelegate {
  func didTapAvatarImage(indexPath: IndexPath)
}

class UserCell: UITableViewCell {

  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var name: UILabel!

  var indexPath: IndexPath!
  var tapGestureRecognizer = UITapGestureRecognizer()
  var delegate: UserCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()

    tapGestureRecognizer.addTarget(self, action: #selector(self.avatarTap))
    avatar.isUserInteractionEnabled = true
    avatar.addGestureRecognizer(tapGestureRecognizer)
  }

  @objc func avatarTap() {
    delegate?.didTapAvatarImage(indexPath: indexPath)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func generateCellWith(fUser: FUser, indexPath: IndexPath) {
    self.indexPath = indexPath
    name.text = fUser.fullname

    if fUser.avatar != "" {
      imageFromData(pictureData: fUser.avatar) { image in
        if image != nil {
          self.avatar.image = image!.circleMasked
        }
      }
    }
  }

}
