//
//  TabBarViewController.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupControllers()
    }

	private func setupControllers() {
		guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else { return }
		
		let homeVC = HomeViewController()
		let profileVC = ProfileViewController(currentEmail: currentUserEmail)
		
		homeVC.title = "Home"
		profileVC.title = "Profile"
		homeVC.navigationItem.largeTitleDisplayMode = .always
		profileVC.navigationItem.largeTitleDisplayMode = .always
		
		let navigationHomeVC = UINavigationController(rootViewController: homeVC)
		let navigationProfileVC = UINavigationController(rootViewController: profileVC)
		navigationHomeVC.navigationBar.prefersLargeTitles = true
		navigationProfileVC.navigationBar.prefersLargeTitles = true
		navigationHomeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
		navigationProfileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
		
		setViewControllers([navigationHomeVC, navigationProfileVC], animated: true)
	}
}
