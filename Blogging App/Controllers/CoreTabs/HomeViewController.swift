//
//  ViewController.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import UIKit

class HomeViewController: UIViewController {

	private let composeButton: UIButton = {
		let button = UIButton()
		button.backgroundColor = .systemBlue
		button.tintColor = .white
		button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
		button.layer.cornerRadius = 30
		button.layer.shadowColor = UIColor.label.cgColor
		button.layer.shadowOpacity = 0.4
		button.layer.shadowRadius = 10
		
		return button
	}()
	
	private let tableView: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		table.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
		
		return table
	}()
	
	private var posts: [BlogPost] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		view.addSubview(tableView)
		view.addSubview(composeButton)
		composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
		tableView.delegate = self
		tableView.dataSource = self
		fetchAllPosts()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		composeButton.frame = CGRect(x: view.frame.width - 88,
									 y: view.frame.height - 88 - view.safeAreaInsets.bottom,
									 width: 60,
									 height: 60)
		tableView.frame = view.bounds
	}
	
	private func fetchAllPosts() {
		DatabaseManager.shared.getAllPosts { [weak self] post in
			self?.posts = post
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
	}

	@objc private func didTapCreate() {
		let vc = CreateNewPostViewController()
		vc.title = "Create Post!"
		let navVC = UINavigationController(rootViewController: vc)
		present(navVC, animated: true, completion: nil)
	}
}

// MARK: -  UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as! PostPreviewTableViewCell
		
		let post = posts[indexPath.row]
		
		cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl))
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		100
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		Haptics.shared.vibrateForSelection()
		
		guard IAPMAnager.shared.canViewPost else {
			let vc = PayWallViewController()
			present(vc, animated: true)
			return
		}
		
		let vc = ViewPostViewController(post: posts[indexPath.row])
		vc.navigationItem.largeTitleDisplayMode = .never
		vc.title = "Post"
		navigationController?.pushViewController(vc, animated: true)
	}
}
