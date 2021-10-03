//
//  PayWallViewController.swift
//  Blogging App
//
//  Created by Alexandr on 03.10.2021.
//

import UIKit

class PayWallViewController: UIViewController {
	
	private let header = PayWallHeaderView()
	private let heroView = PayWallDescriptionView()
	
	private let termsView: UITextView = {
		let textView = UITextView()
		textView.isEditable = false
		textView.textAlignment = .center
		textView.font = .systemFont(ofSize: 14)
		textView.textColor = .secondaryLabel
		textView.text = "This is an auto-renewable Subscription. It will be charged to your iTunes account before each pay period. You can cancel anytime by going into your Settings -> Subscriptions. Restore purchases if previously subscribed."
		
		return textView
	}()
	
	private let buyButton: UIButton = {
		let button = UIButton()
		button.setTitle("Subscribe", for: .normal)
		button.backgroundColor = .systemGray2
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 8
		button.layer.masksToBounds = true
		
		return button
	}()
	
	private let restoreButton: UIButton = {
		let button = UIButton()
		button.setTitle("Restore Purchases", for: .normal)
		button.setTitleColor(.link, for: .normal)
		button.layer.cornerRadius = 8
		button.layer.masksToBounds = true
		
		return button
	}()

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Thoughts Premium"
		view.backgroundColor = .systemBackground
		view.addSubview(header)
		view.addSubview(heroView)
		view.addSubview(buyButton)
		view.addSubview(restoreButton)
		view.addSubview(termsView)
		setupButtons()
		setupCloseButton()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		header.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height / 3.2)
		termsView.frame = CGRect(x: 10, y: view.height - 100, width: view.width - 20, height: 100)
		restoreButton.frame = CGRect(x: 25, y: termsView.top - 70, width: view.width - 50, height: 50)
		buyButton.frame = CGRect(x: 25, y: restoreButton.top - 60, width: view.width - 50, height: 50)
		heroView.frame = CGRect(x: 0, y: header.bottom, width: view.width, height: buyButton.top - view.safeAreaInsets.top - header.height)
	}
	
	private func setupButtons() {
		buyButton.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside)
		restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
		
	}
	
	@objc private func didTapSubscribe() {
		
	}
	
	@objc private func didTapRestore() {}
	
	
	private func setupCloseButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
	}
	
	@objc private func didTapClose() {
		dismiss(animated: true, completion: nil)
	}
}
