//
//  HomeViewController.swift
//  WhatsApps
//
//  Created by Usama on 19/02/2021.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {

    
    
    //MARK: - @IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var tabBarImageButton: UIButton!
    
    //MARK: - Class Properties
    var imagePickerController = UIImagePickerController()
    var homeVideosArray: [VideosModel]?
    var onDisplayVideoID: String?
    var videoLikesCount: Int?
    var homeLikedVideos: [VideosModel]?
    var commentInfo: UserInfo?
    var userData: [UserInfo]?
    
    //MARK:- Base Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.tabBarController?.delegate = self
        
        initialSetup()
    }
}
//MARK:- Class Methods

extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeVideosArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.homePlayerView.contentMode = .scaleAspectFill
        cell.configureCell(video: homeVideosArray?[indexPath.row] ?? VideosModel())
        cell.likedVideosUpdate(likedVideo: homeLikedVideos ?? [VideosModel]())
        if indexPath.row > (userData?.count ?? 0)-1{
            print("Cannot Load Image")
        }
        else {
            cell.homeImageUser(userData: userData?[indexPath.row] ?? UserInfo())
        }
        if let likeNumber = homeVideosArray![indexPath.row].likesCount {
            cell.likesLabel.text = "\(likeNumber) Likes"
        }
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = (cell as? HomeCollectionViewCell) else { return };
        _ = collectionView.visibleCells
        let visibleCells = collectionView.visibleCells
        let minIndex = visibleCells.startIndex
        onDisplayVideoID =  homeVideosArray?[minIndex].id
            videoCell.homePlayerView.player?.play()
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? HomeCollectionViewCell else { return };
        videoCell.homePlayerView.player?.pause()
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.bounds.height)
    }
}

extension HomeViewController {
    
    fileprivate func initialSetup() {
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = collectionLayout
        
        self.navigationItem.title = "Home"
        self.navigationItem.hidesBackButton = true
        
        collectionView.layer.cornerRadius = 10
        tabBarImageButton.layer.cornerRadius = tabBarImageButton.frame.size.height/2
        
        let video = VideoViewModel()
        if (MManager.shared.homeVideosArray == nil) {
            video.getHomeVideos { (videoURLS) in
                self.homeVideosArray = videoURLS
                self.collectionView.reloadData()
            }
        }
        else {
            self.homeLikedVideos = MManager.shared.homeLikedVideosArray
            self.homeVideosArray = MManager.shared.homeVideosArray
            self.collectionView.reloadData()
        }
        if (MManager.shared.homeLikedVideosArray == nil){
            video.likedVideoCheck { (likedVideos) in
                self.homeLikedVideos = likedVideos
            }
        }
        else{
            print("No Home Video Found")
        }
        let user = UserViewModel()
        user.getUserDataFromFirebase { (userData) in
            self.userData = userData
        }
    }
}
    //MARK: - @IBActions
extension HomeViewController{
    
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
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let user = UserViewModel()
        user.logOutUser { (response) in
            if response == true{
               print("User Logged Out")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
