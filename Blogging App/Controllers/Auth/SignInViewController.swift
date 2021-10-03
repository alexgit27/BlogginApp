//
//  SignInViewController.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
		view.backgroundColor = .systemBackground
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			if !IAPMAnager.shared.isPremium() {
				let vc = PayWallViewController()
				let navVC = UINavigationController(rootViewController:vc)
				
				self.present(navVC, animated: true, completion: nil)
			}
		}
    }

}
