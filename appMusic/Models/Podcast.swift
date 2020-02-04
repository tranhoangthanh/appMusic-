//
//  Podcast.swift
//  appMusic
//
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import Foundation

class Podcast : NSObject, Decodable , NSCoding {
    func encode(with coder: NSCoder) {
        //biến Podcast thành Data
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        coder.encode(artworkUrl600 ?? "", forKey: "artworkUrl600Key")
        coder.encode(feedUrl ?? "", forKey: "feedUrlKey")
    }
    
    required init?(coder: NSCoder) {
        //biến Data thành Podcast
        self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = coder.decodeObject(forKey: "artworkUrl600Key") as? String
        self.feedUrl = coder.decodeObject(forKey: "feedUrlKey") as? String
    }
    
    var trackName : String?
    var artistName : String?
    var artworkUrl600 : String?
    var trackCount : Int?
    var feedUrl : String?
}
