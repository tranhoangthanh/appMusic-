//
//  PodcastsSearchController .swift
//  appMusic
//
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController : UITableViewController , UISearchBarDelegate {
    
    var podcasts: [Podcast] = []
    
    //khởi tạo UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        podcasts = []
        tableView.reloadData()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            APIService.shared.fetchPodcasts(searchText: searchText) { podcasts in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK:- Setup PodcastsSearchController
    
    fileprivate func setupTableView() {
        tableView.register(PodcastTableViewCell.nib, forCellReuseIdentifier: PodcastTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    //MARK:- UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PodcastTableViewCell.reuseIdentifier , for: indexPath) as! PodcastTableViewCell
        cell.configure(podcast: self.podcasts[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20 , weight: .semibold)
        label.textColor = .purple
        return label
    }
    
    var podcastSearchView = PodcastsFooterView.viewFromNib
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return podcastSearchView
    }
    
    
    //MARK:- Variable height support
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return podcasts.isEmpty && searchController.searchBar.text?.isEmpty == false ? 200 : 0
    }
    
    //MARK: -TableView Delegate
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let episodeController = EpisodesController()
           let podcast = self.podcasts[indexPath.row]
           episodeController.podcast = podcast
           navigationController?.pushViewController(episodeController, animated: true)
       }
   
}
