//
//  CommentTableViewCell.swift
//  WhatsApps
//
//  Created by Usama on 23/02/2021.
//

import Foundation
import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userCommentTextView: UITextView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
 
    func configureCell(comment: CommentModel){
        if let url = URL(string: comment.imageURL ?? "")
        {
        let data = try? Data(contentsOf: url)
            self.userImageView?.image = UIImage(data: data ?? Data())
        }
        self.userImageView.contentMode = .scaleAspectFill
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.masksToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width/2
        self.userCommentTextView.text = comment.commentMessage
        self.userNameLabel.text = comment.userName
        self.userNameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.timeLabel.text = comment.commentTime
    }
}
