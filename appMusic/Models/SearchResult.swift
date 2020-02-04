//
//  SearchResult.swift
//  appMusic
//
//  Created by Trần Thành on 1/11/20.
//  Copyright © 2020 Trần Thành. All rights reserved.
//

import UIKit

struct SearchResults: Decodable {
  let resultCount: Int
  let results: [Podcast]
}

