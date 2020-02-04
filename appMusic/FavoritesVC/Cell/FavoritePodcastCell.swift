//
//  FavoritesCell.swift
//  appMusic
//
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import LBTATools

class FavoritePodcastCell : UICollectionViewCell {
    
    var podcast : Podcast! {
        didSet{
            nameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            let url = URL(string: podcast.artworkUrl600 ?? "")
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "appicon"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Podcast Name", font: UIFont.boldSystemFont(ofSize: 18), textColor: .black, textAlignment: .left, numberOfLines: 1)
    let artistNameLabel = UILabel(text: "Artist Name", font: UIFont.systemFont(ofSize: 16), textColor: .lightGray, textAlignment: .left, numberOfLines: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.withHeight(frame.width)
        stack(imageView,
              nameLabel,
              artistNameLabel
              )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
