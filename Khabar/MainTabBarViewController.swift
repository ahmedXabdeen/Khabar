//
//  ViewController.swift
//  Khabar
//
//  Created by Ahmed Abdeen on 07/01/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: AboutViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc1.tabBarItem.title = "Home"
        
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc2.tabBarItem.title = "Search"
        
        vc3.tabBarItem.image = UIImage(systemName: "info")
        vc3.tabBarItem.title = "About"
        
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3], animated: true)
    }


}

