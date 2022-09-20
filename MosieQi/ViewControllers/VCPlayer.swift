//
//  VCPlayer.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/08/2022.
//

import UIKit
import Lottie
import MarqueeLabel
import AVFoundation
import AVKit
import youtube_ios_player_helper_swift

protocol PlayerDelegate: AnyObject{
    func stateOfPlayer(index: Int, player: YTPlayerView)
}


class VCPlayer: UIViewController {

    weak var delegate: PlayerDelegate?
    
    var items: [Item] = []
    var selectedIndex = 0
    var isPlaying = false
    var videoPlayer = YTPlayerView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))

    @IBOutlet weak var lblTitle: MarqueeLabel!
    @IBOutlet weak var btnFav: AnimatedButton!
    @IBOutlet weak var imgBGPlayer: UIImageView!
    @IBOutlet weak var imageViewForSmallImg: UIImageView!
    @IBOutlet weak var lblChannelName: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFav.translatesAutoresizingMaskIntoConstraints = false
        btnFav.animation = Animation.named("heart-fav")
//        btnFav.clipsToBounds = false
        btnFav.setPlayRange(fromMarker: "touchDownStart", toMarker: "touchDownEnd", event: .touchDown)
        
        setupMarqueeTitle()

        Utilities.shared.setImageFromUrl(imgView: imgBGPlayer, url: items[selectedIndex].snippet.thumbnails.high?.url ?? "")
        Utilities.shared.setImageFromUrl(imgView: imageViewForSmallImg, url: items[selectedIndex].snippet.thumbnails.high?.url ?? "")
        lblTitle.text = items[selectedIndex].snippet.title
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if videoPlayer.playerState == .playing{
            btnPlayPause.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }else{
            btnPlayPause.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.stateOfPlayer(index: selectedIndex, player: videoPlayer)
    }
    fileprivate func setupMarqueeTitle() {
        lblTitle.type = .continuous
        lblTitle.speed = .rate(15.0)
        lblTitle.animationCurve = .easeInOut
        lblTitle.fadeLength = 10.0
        lblTitle.leadingBuffer = 0
        lblTitle.trailingBuffer = 0
    }
    @IBAction func onBackwordsTapped(_ sender: UIButton) {
    }
    
    @IBAction func onPlayPausedTapped(_ sender: UIButton) {
        if videoPlayer.playerState == .playing{
            videoPlayer.pauseVideo()
            btnPlayPause.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }else{
            videoPlayer.playVideo()
            btnPlayPause.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func onForwardTapped(_ sender: UIButton) {
        if videoPlayer.playerState == .playing{
            videoPlayer.stopVideo()
            btnPlayPause.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
        selectedIndex += 1
        if selectedIndex < items.count{
            _ = videoPlayer.load(videoId: items[selectedIndex].snippet.resourceID.videoID, playerVars: playerVars)
            btnPlayPause.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }else{
            selectedIndex -= 1
        }
    }
}
