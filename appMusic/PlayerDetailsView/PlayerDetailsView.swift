//
//  PlayerDetailsView.swift
//  appMusic
//
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import AVKit


class PlayerDetailsView: UIView {
    
    let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    static func initFromNib() -> PlayerDetailsView{
        return PlayerDetailsView.viewFromNib as! PlayerDetailsView
    }
    
    //MARK: -MiniView
    @IBOutlet weak var miniFastForwardButton: UIButton! {
        didSet {
            self.miniFastForwardButton.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            self.miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniTitleLabel: UILabel!
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniPlayerView: UIView!
    
    //MARK:  -MaxStackView
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            self.episodeImageView.layer.cornerRadius = 5
            self.episodeImageView.transform = self.shrunkenTransform
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        }, completion: nil)
    }
    
    fileprivate func shinkEpisodeImageView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        }, completion: nil)
    }
    
    @IBAction func handleDismiss(_ sender: Any) {
        let mainTabbarController = UIApplication.mainTabBarController
        mainTabbarController?.minimizePlayerDetails()
    }
    
    var episode : Episode? {
        didSet{
            titleLabel.text = self.episode?.title
            miniTitleLabel.text = self.episode?.title
            authorLabel.text = self.episode?.author
            playEpisode()
            guard let url = URL(string: self.episode?.imageUrl ?? "") else {return}
            episodeImageView.sd_setImage(with: url, completed: nil)
            miniEpisodeImageView.sd_setImage(with: url, completed: nil)
            
        }
    }
    
    fileprivate func playEpisode(){
        if episode?.fileUrl != nil {
            playEpisodeUsingFileUrl()
        } else {
            print("Trying to player episode at url : ", episode?.streamUrl ?? "")
            guard let url = URL(string: self.episode?.streamUrl ?? "") else {return}
            let playerItem = AVPlayerItem(url: url)
            self.player.replaceCurrentItem(with: playerItem)
            player.play()
        }
        
    }
    
    fileprivate func playEpisodeUsingFileUrl(){
        print("Attempt to play episode with file url:",episode?.fileUrl ?? "")
        guard let fileURL = URL(string: episode?.fileUrl ?? "") else { return }
        let fileName = fileURL.lastPathComponent

        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        trueLocation.appendPathComponent(fileName)
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    let player : AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    @IBOutlet weak var playPauseButton: UIButton!{
        didSet {
            self.playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause(){
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            self.enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            self.shinkEpisodeImageView()
        }
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) {
            [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationTime?.toDisplayString()
            self?.updateCurrentTimeSlider()
        }
    }
    
    fileprivate func updateCurrentTimeSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds =  CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    //MARK: -awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        observePlayerCurrentTime()
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time : time)]
        //player reference to self
        //self reference to player
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {
            [weak self] in
            self?.enlargeEpisodeImageView()
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
    }
    
    @objc func handleTapMaximize(){
        let mainTabbarController = UIApplication.mainTabBarController
               mainTabbarController?.maximizePlayerDetails(episode : nil)
    }
    
      //MARK: -Action

    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
        let precentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(precentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
        
    }
    
    fileprivate func seekToCurrentTime(delta : Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    
    
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
}
