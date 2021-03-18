//
//  ProfileCollectionViewCell.swift
//  WhatsApps
//
//  Created by Usama on 19/02/2021.
//

import UIKit
import AVKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    //MARK:- @IBOutlets
    @IBOutlet weak var profilePlayerView: ProfilePlayerView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    //MARK:- Class Properties
    var likedVideosArray : [VideosModel]?
    var videoID: String?
    var likesCount: Int?

    //MARK:- Class Methods
    func configureCell(video: VideosModel) {
        let url = NSURL(string: (video.url ?? "")!)
        let userData = MManager.shared.profileUser ?? UserInfo()
        let avPlayer = AVPlayer(url: url! as URL)
        self.profilePlayerView.playerLayer.frame = self.bounds
        self.profilePlayerView.playerLayer.player = avPlayer
        self.usernameLabel.text = userData.firstName
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.masksToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width/2
        self.usernameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        if let imageURL = URL(string: userData.imageURL ?? "")
        {
            let data = try? Data(contentsOf: imageURL)
            self.userImageView?.image = UIImage(data: data ?? Data())
        }
        self.videoID = video.id ?? ""
        likesCount = video.likesCount
        
    }
    
    func likedVideosUpdate(likedVideo: [VideosModel]){
        
        likedVideo.forEach { (likeCheck) in
            
            if likeCheck.id == videoID{
                likeButton.setTitleColor(.systemBlue, for: .normal)
                likeButton.setTitle("Liked", for: .normal)
            }
        }
    }
    
    //MARK:-@IBActions
    @IBAction func likeButtonPressed(_ sender: Any) {
        let videoViewModel = VideoViewModel()
        if likeButton.currentTitle == "Liked"{
            likesCount! -= 1
            videoViewModel.updataLikesCount(videoID: videoID ?? "", likesCount: likesCount ?? 0, isLiked: true) { (response) in
                if response == true {
                    if let likes = self.likesCount {
                        self.likesLabel.text = "\(likes) Likes"
                        self.likeButton.setTitleColor(.black, for: .normal)
                        self.likeButton.setTitle("Like", for: .normal)
                    }
                }
            }
        }
        else {
            likesCount! += 1
            videoViewModel.updataLikesCount(videoID: videoID ?? "", likesCount: likesCount ?? 0, isLiked: false) { [self] (bool) in
                if bool == true {
                    if let likes = likesCount{
                        self.likesLabel.text = "\(likes) Likes"
                        self.likeButton.setTitleColor(.systemBlue, for: .normal)
                        self.likeButton.setTitle("Liked", for: .normal)
                    }
                }
            }
        }
        videoViewModel.myLikedVideos(videoID: videoID ?? "")
    }
}
