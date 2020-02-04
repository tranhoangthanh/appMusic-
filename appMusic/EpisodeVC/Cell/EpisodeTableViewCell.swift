//
//  EpisodeTableViewCell.swift
//  appMusic
//
//  Created by Trần Thành on 1/24/20.
//  Copyright © 2020 Trần Thành. All rights reserved.
//

import UIKit

class  EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var pubDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(episode : Episode) {
        titleLabel.text = episode.title
        descriptionLabel.text = episode.description
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "MMM dd, yyyy"
        pubDateLabel.text = dateFomatter.string(from: episode.pubDate)
        let url = URL(string: episode.imageUrl ?? "")
        episodeImageView.sd_setImage(with: url, completed: nil)
    }
}
