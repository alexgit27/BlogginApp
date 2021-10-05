//
//  ProfileViewController.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .systemBackground
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutTapped))
    }
	
	@objc private func signOutTapped() {
		let sheet = UIAlertController(title: "Sign Out", message: nil, preferredStyle: .actionSheet)
		sheet.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
		sheet.addAction(.init(title: "Sign Out", style: .destructive, handler: { _ in
			AuthManager.shared.signOut { [weak self] success in
				if success {
					DispatchQueue.main.async {
						UserDefaults.standard.setValue(nil, forKey: "email")
						UserDefaults.standard.setValue(nil, forKey: "name")
						
						let signInVC = SignInViewController()
						signInVC.navigationItem.largeTitleDisplayMode = .always

						let navVC = UINavigationController(rootViewController: signInVC)
						navVC.navigationBar.prefersLargeTitles = true
						navVC.modalPresentationStyle = .fullScreen

						self?.present(navVC, animated: true, completion: nil)
					}
				}
			}
		}))
		
		self.present(sheet, animated: true, completion: nil)
	}
}
