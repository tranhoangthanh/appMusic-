//
//  EpisodeController.swift
//  appMusic
//
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesController : UITableViewController {
    
    var podcast : Podcast? {
        didSet {
            navigationItem.title = self.podcast?.trackName
            fetchEpisodes()
        }
    }
    
    var episodes : [Episode] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButtons()
        
    }
    
    //MARK:- Setup EpisodesViewController
    fileprivate func setupNavigationBarButtons(){
           let savedPodcasts = UserDefaults.standard.savedPodcasts()
           let hasFavorited = savedPodcasts.index(where: {
               $0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName
           }) != nil
           
           if hasFavorited {
               //setup icon
               navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart")  .withRenderingMode(.alwaysOriginal)  ,   style: .plain, target: nil, action: nil)
           } else {
               navigationItem.rightBarButtonItems = [
                   UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
               ]
           }
           
       }
    @objc func handleSaveFavorite(){
        // lưu thông tin vào UserDefaults
        guard let podcast = self.podcast else {return}
        //biến podcast thành data
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts)
         UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
        showBadgeHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem( image: #imageLiteral(resourceName: "heart")  .withRenderingMode(.alwaysOriginal)  , style: .plain, target: nil, action: nil)
        
    }
    
    fileprivate func showBadgeHighlight(){
   UIApplication.mainTabBarController?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    
    fileprivate func setupTableView() {
           tableView.tableFooterView = UIView()
        tableView.register( EpisodeTableViewCell.nib, forCellReuseIdentifier:  EpisodeTableViewCell.reuseIdentifier)
    }
     
    fileprivate func fetchEpisodes(){
          guard let feedUrl = podcast?.feedUrl else {return}
          APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
              self.episodes = episodes
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
          }
      }
   
     //MARK:- UITableView DataSoure
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:  EpisodeTableViewCell.reuseIdentifier, for: indexPath) as!  EpisodeTableViewCell
        let episode = episodes[indexPath.row]
        cell.configure(episode: episode)
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicatorView.color = .red
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
   
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
//            let episode = self.episodes[indexPath.row]
//            UserDefaults.standard.downloadEpisode(episode: episode)
//        }
//        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
//        return swipeActions
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
         let episode = self.episodes[indexPath.row]
         UserDefaults.standard.downloadEpisode(episode: episode)
         APIService.shared.downloadEpisode(episode: episode)
       }
       return [downloadAction]
     }
     
     //MARK:- Variable height support
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    //MARK: -TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        let mainTabbarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabbarController?.maximizePlayerDetails(episode : episode)
    }
}
