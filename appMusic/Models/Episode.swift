//
//  Episode.swift
//  appMusic
//
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import FeedKit

struct Episode: Codable {
  let title: String
  let pubDate: Date
  let description: String
  let author: String
  var imageUrl: String?
  let streamUrl: String
  var fileUrl: String?

    
  init(feedItem: RSSFeedItem) {
    self.title = feedItem.title ?? ""
    self.pubDate = feedItem.pubDate ?? Date()
    self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
    self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
    self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
  }
    
}

