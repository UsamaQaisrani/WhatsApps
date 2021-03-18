//
//  UserProfileCollectionViewCell.swift
//  WhatsApps
//
//  Created by Usama on 08/03/2021.
//

import Foundation
import UIKit
import AVKit


class UserProfileCollectionViewCell: UICollectionViewCell {
    var videoURL: String?
    @IBOutlet weak var userView: UIImageView!
    
    func configureCell(video: VideosModel){
        videoURL = video.url
       let image =  generateThumbnail()
        userView.layer.cornerRadius = 25
        userView.image = image
    }
    
    func generateThumbnail() -> UIImage? {
        let asset = AVAsset(url: NSURL(string: videoURL ?? "")! as URL)
        let assetImgGenerate = AVAssetImageGenerator (asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch{
            print(error.localizedDescription)
            return nil
        }
    }
    
}
