//
//  APIService.swift
//  appMusic
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import Alamofire
import FeedKit
import UIKit

extension Notification.Name {
  static let downloadProgress = NSNotification.Name("downloadProgress")
  static let downloadComplete = NSNotification.Name("downloadComplete")
}

class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    static let shared = APIService()
    func downloadEpisode(episode : Episode) {
        print("Dowloafing episode using Alamofire at stream url :", episode.streamUrl)
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            //I want to notify DowloadsController about my dowload propress somehow?
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
        }.response { (resp) in
            print(resp.destinationURL?.absoluteString ?? "")
            let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: resp.destinationURL?.absoluteString ?? "", episode.title)
            NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
            // I want to update UserDefaults dowloaded episodes with the temp file somehow
            var dowloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
            guard let index = dowloadedEpisodes.index(where: {
                $0.title == episode.title && $0.author == episode.author
            }) else {return}
            dowloadedEpisodes[index].fileUrl = resp.destinationURL?.absoluteString ?? ""
            do {
                let data = try JSONEncoder().encode(dowloadedEpisodes)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
            } catch let err {
                print("Failed to encode downloaded episodes with file url update:", err)
            }
        }
    }
    
    
    
    func fetchPodcasts(searchText : String ,comletionHandler : @escaping ([Podcast]) -> () ){
        let parameters = ["term": searchText]
        Alamofire.request(EndPoints.iTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("iTunes search failed", error)
                return
            }
            guard let data = dataResponse.data else {return}
            do {
                let searchResult =  try JSONDecoder().decode(SearchResults.self, from: data)
                comletionHandler(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode:", decodeErr)
            }
        }
    }
    
    func fetchEpisodes(feedUrl : String , comletionHandler : @escaping ([Episode]) -> () ) {
        guard let url = URL(string: feedUrl) else {return}
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (result) in
                switch result {
                case .success(let feed):
                    switch feed {
                    case let .rss(feed):
                        let episodes = feed.toEpisode()
                        comletionHandler(episodes)
                        break
                    default :
                        print("Found a feed")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
}
