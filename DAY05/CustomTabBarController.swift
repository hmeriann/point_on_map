//
//  CustomTabBarController.swift
//  DAY05
//
//  Created by Zuleykha Pavlichenkova on 17.08.2022.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBarController()
        setUpViewControllers()
    }
    
    func setUpTabBarController() {
        tabBar.barTintColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
    }
    
    func setUpViewControllers() {
        let mapViewController = MapViewController()
        mapViewController.title = "Map"
        mapViewController.tabBarItem.image = UIImage(systemName: "map")
        
        let listViewController = PlacesTableViewController()
        listViewController.title = "Places"
        listViewController.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        listViewController.delegate = mapViewController
        
        let moreViewController = moreNavigationController
        
        viewControllers = [mapViewController, listViewController, moreViewController]
    }
    
}
