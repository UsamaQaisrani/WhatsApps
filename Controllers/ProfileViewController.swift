//
//  TableViewController.swift
//  WhatsApps
//
//  Created by Usama on 18/02/2021.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Class Properties
    var imagePickerController = UIImagePickerController()
    var profileVideosArray: [VideosModel]?
    var videoLikesCount: Int?
    var profileLikedVideosArray: [VideosModel]?
    var commentInfo: UserInfo?
    var onDisplayVideoID: String?
    var index: Int?


    //MARK:- Base Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.collectionView.isPagingEnabled = false
        let indexPath = IndexPath(item: index ?? 0, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        self.collectionView.isPagingEnabled = true
    }
}
//MARK:- Class Methods

extension ProfileViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.profileVideosArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.profilePlayerView.contentMode = .scaleAspectFill
        cell.configureCell(video: profileVideosArray?[indexPath.row] ?? VideosModel())
        cell.likedVideosUpdate(likedVideo: profileLikedVideosArray ?? [VideosModel]())
        if let likeNumber = profileVideosArray![indexPath.row].likesCount {
            cell.likesLabel.text = "\(likeNumber) Likes"
        }
        return cell
    }
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = (cell as? ProfileCollectionViewCell) else { return };
        onDisplayVideoID =  profileVideosArray?[indexPath.row].id
        videoCell.profilePlayerView.player?.play()

    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? ProfileCollectionViewCell else { return };
        videoCell.profilePlayerView.player?.pause()
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}

extension ProfileViewController:  UINavigationControllerDelegate {
    
    fileprivate func initialSetup(){
        navigationController?.visibleViewController?.navigationItem.title = "Videos"
        collectionView.layer.cornerRadius = 10
        self.tabBarController?.tabBar.isHidden = true
        
        let video = VideoViewModel()
        if (MManager.shared.profileVideosArray == nil) {
            video.getVideoDownloadURL { (videosURLS) in
                self.profileVideosArray = videosURLS
                self.collectionView.reloadData()
            }
        }
        else {
            self.profileVideosArray = MManager.shared.profileVideosArray
            self.collectionView.reloadData()
        }
        
        if (MManager.shared.homeLikedVideosArray == nil){
            print("No Liked Video")
        }
        else {
            self.profileLikedVideosArray = MManager.shared.homeLikedVideosArray
        }
        
    }
}

    //MARK:- @IBActions
extension ProfileViewController{
    
    @IBAction func commentButtonPressed(_ sender: Any) {
        let videoViewModel = VideoViewModel()
        videoViewModel.getInfoForComment { (comment) in
            self.commentInfo = comment
            if self.commentInfo != nil {
                _ = CommentViewController(nibName: "CommentViewController", bundle: nil)
                let commentViewController = self.storyboard?.instantiateViewController(identifier: "commentViewControllerID") as! CommentViewController
                commentViewController.commentInfo = self.commentInfo
                commentViewController.videoID = self.onDisplayVideoID
                self.present(commentViewController, animated: true, completion: nil)
            }
        }
    }
}
