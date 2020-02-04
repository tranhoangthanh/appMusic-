//
//  MainTabBarController.swift
//  appMusic
//
//  Created by Trần Thành on 12/29/19.
//  Copyright © 2019 Trần Thành. All rights reserved.
//

import UIKit
import LBTATools

class MainTabBarController : UITabBarController {
    
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    let playerDetailsView = PlayerDetailsView.initFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple
        setupViewController()
        setupPlayerDetailsView()
      
    }
    func minimizePlayerDetails(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.maximizedTopAnchorConstraint.isActive = false
            self.minimizedTopAnchorConstraint.isActive = true
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = false
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        }, completion: nil)
    }
    
     func maximizePlayerDetails(episode: Episode?){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.maximizedTopAnchorConstraint.isActive = true
            self.maximizedTopAnchorConstraint.constant = 0
            self.minimizedTopAnchorConstraint.isActive = false
            if episode != nil {
                self.playerDetailsView.episode = episode
            }
            self.view.layoutIfNeeded()
            self.tabBar.isHidden = true
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
        }, completion: nil)
    }
    
    fileprivate func setupPlayerDetailsView(){
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        playerDetailsView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor , constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizedTopAnchorConstraint.isActive = true
    }
    
    

    fileprivate func setupViewController(){
        viewControllers =
            [
                generateNavigationController(rootViewController: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search")),
                generateNavigationController(rootViewController: FavoritesController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
                generateNavigationController(rootViewController: DownloadsTableViewController(), title: "Dowloads", image: #imageLiteral(resourceName: "downloads")),
            ]
    }
    
    
    fileprivate func generateNavigationController(rootViewController : UIViewController,title : String, image : UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}
