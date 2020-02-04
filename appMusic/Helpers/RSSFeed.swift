//
//  RSSFeed.swift
//  appMusic
//
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import FeedKit

extension RSSFeed {
    func toEpisode() -> [Episode] {
        var episodes = [Episode]()
        items?.forEach({(feedItem) in
            let episode = Episode(feedItem: feedItem)
            episodes.append(episode)
        })
        return episodes
    }
}
