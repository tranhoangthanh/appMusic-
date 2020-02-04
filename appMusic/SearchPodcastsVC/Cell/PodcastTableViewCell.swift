//
//  PodcastTableViewCell.swift
//  appMusic
//
//  Created by Trần Thành on 1/24/20.
//  Copyright © 2020 Trần Thành. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastTableViewCell : UITableViewCell {
    
    @IBOutlet weak var podcastImageView : UIImageView!
    @IBOutlet weak var trackNameLabel : UILabel!
    @IBOutlet weak var artistNameLabel : UILabel!
    @IBOutlet weak var episodeCountLabel : UILabel!
    
    func configure(podcast : Podcast) {
        trackNameLabel.text = podcast.trackName
        artistNameLabel.text = podcast.artistName
        guard let url = URL(string: podcast.artworkUrl600 ?? "") else {return}
        podcastImageView.sd_setImage(with: url, completed: nil)
        episodeCountLabel.text = "\(podcast.trackCount ?? 0) Tập"
    }
}
