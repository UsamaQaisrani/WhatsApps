//
//  TableViewCellClass.swift
//  VideosApp
//
//  Created by Usama on 11/02/2021.
//

import UIKit
import AVKit

class HomeCollectionViewCell: UICollectionViewCell {
    //MARK:- @IBOutlets
    @IBOutlet weak var homePlayerView: HomePlayerView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK:-Class Properties
    var homeLikedVideosArray : [VideosModel]?
    var videoID: String?
    var likesCount: Int?
    
    //MARK:- Class Methods
    func configureCell(video: VideosModel) {
        let url = NSURL(string: (video.url ?? "")!)
        let avPlayer = AVPlayer(url: url! as URL)
        self.homePlayerView.playerLayer.frame = self.bounds
        self.homePlayerView.playerLayer.player = avPlayer
        self.layer.cornerRadius = 10
        if let vidID = video.id{
            videoID = vidID
        }
        likesCount = video.likesCount
    }
    
    func likedVideosUpdate(likedVideo: [VideosModel]){
      
        likedVideo.forEach { (likedVideo) in
            
            if likedVideo.likedVideoCheck == true{
                likeButton.setTitleColor(.systemBlue, for: .normal)
                likeButton.setTitle("Liked", for: .normal)
            }
        }
    }
    
    func homeImageUser(userData: UserInfo){
        self.usernameLabel.text = userData.firstName
        if let imageURL = URL(string: userData.imageURL ?? "")
        {
            let data = try? Data(contentsOf: imageURL)
            self.userImageView?.image = UIImage(data: data ?? Data())
        }
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.masksToBounds = true
        self.userImageView.layer.cornerRadius = self.userImageView.frame.width/2
        self.usernameLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    }
    
    //MARK:- @IBActions
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
