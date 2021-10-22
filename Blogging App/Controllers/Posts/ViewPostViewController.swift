//
//  ViewPostViewController.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import UIKit

class ViewPostViewController: UIViewController {

	private let post: BlogPost
	private let isOwnedByCurrentUser: Bool
	
	init(post: BlogPost, isOwnedByCurrentUser: Bool = false) {
		self.post = post
		self.isOwnedByCurrentUser = isOwnedByCurrentUser
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let tableView: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		table.register(PostHeaderTableViewCell.self, forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
		
		return table
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .systemBackground
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		
		if !isOwnedByCurrentUser {
			IAPMAnager.shared.logPostView()
		}
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		tableView.frame = view.bounds
	}
    

}

// MARK: -  UITableViewDelegate, UITableViewDataSource
extension ViewPostViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let index = indexPath.row
		
		switch index {
		case 0:
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			if #available(iOS 14.0, *) {
				var content = cell.defaultContentConfiguration()
				content.text = post.title
				content.textProperties.font = .systemFont(ofSize: 25, weight: .bold)
				cell.contentConfiguration = content
			}
			cell.selectionStyle = .none
			return cell
		case 1:
			let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as! PostHeaderTableViewCell
			cell.configure(with: .init(imageUrl: post.headerImageUrl))
			cell.selectionStyle = .none
			return cell
		case 2:
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			if #available(iOS 14.0, *) {
				var content = cell.defaultContentConfiguration()
				content.text = post.text
				cell.contentConfiguration = content
			}
			cell.selectionStyle = .none
			return cell
		default: fatalError()
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let index = indexPath.row
		
		switch index {
		case 0: return UITableView.automaticDimension
		case 1: return 150
		case 2: return UITableView.automaticDimension
		default: return UITableView.automaticDimension
		}
	}
}
