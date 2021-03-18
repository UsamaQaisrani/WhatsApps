//
//  PlayerView.swift
//  VideosApp
//
//  Created by Usama on 11/02/2021.
//
import UIKit
import AVKit;
import AVFoundation;

class HomePlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
