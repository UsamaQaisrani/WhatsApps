//
//  UserViewController.swift
//  WhatsApps
//
//  Created by Usama on 01/03/2021.
//

import UIKit

class UserViewController: UIViewController, UINavigationControllerDelegate {
    //MARK:- Class Properties
    var profileVideosArray: [VideosModel]?
    private let spacing:CGFloat = 5
    var imagePickerController = UIImagePickerController()
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addImageButton: UIButton!
    
    //MARK:- Base Method
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        initialSetup()
    }
}

//MARK:- Class Methods

extension UserViewController: UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.mediaURL] as? URL {
            let tempURL = createTemporaryURLforVideoFile(url: url)
            let videoURL = VideosModel(url: tempURL.absoluteString)
            let videoUpload = VideoViewModel(videoURL: videoURL)
            videoUpload.getURL { urlString in
                print("Videos Uploaded")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UserViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileVideosArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileCollectionViewCell", for: indexPath) as! UserProfileCollectionViewCell
        cell.configureCell(video: profileVideosArray?[indexPath.row] ?? VideosModel())
        return cell
    }
    
}

extension UserViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 10
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    
    
}

extension UserViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(identifier: "profileViewController") as! ProfileViewController
        vc.index = indexPath.row
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension UserViewController{
    
    func initialSetup(){
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = "Profile"
        self.navigationItem.hidesBackButton = true
        
        addImageButton.layer.cornerRadius = addImageButton.frame.size.height/2
        getUserData()
        getVideos()
    }
    
    func getUserData(){
        let userData = MManager.shared.profileUser ?? UserInfo()
        self.usernameLabel.text = "\(userData.firstName ?? "") \(userData.lastName ?? "")"
        if let imageURL = URL(string: userData.imageURL ?? "")
        {
            let data = try? Data(contentsOf: imageURL)
            self.userImageView?.image = UIImage(data: data ?? Data())
        }
    }
    
    func getVideos(){
        
        let video = VideoViewModel()
        if (MManager.shared.profileVideosArray == nil) {
            video.getVideoDownloadURL { (videoURLS) in
                self.profileVideosArray = videoURLS
                self.collectionView.reloadData()
            }
        }
        else {
            self.profileVideosArray = MManager.shared.profileVideosArray
            self.collectionView.reloadData()
        }
    }
    
    func createTemporaryURLforVideoFile(url: URL) -> URL {
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent(url.lastPathComponent )
        do {
            try FileManager().copyItem(at: url.absoluteURL, to: temporaryFileURL)
        } catch {
            print("There was an error copying the video file to the temporary location.")
        }
        return temporaryFileURL as URL
    }
}
    //MARK:- IBActions
extension UserViewController {
    
    @IBAction func addVideoButton(_ sender: Any) {
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        let actionSheet = UIAlertController(title: "Video Source",message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.cameraDevice = .rear
            self.imagePickerController.cameraCaptureMode = .video
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (UIAlertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        self.present(actionSheet, animated: true, completion: nil)
        collectionView.reloadData()
    }
}
