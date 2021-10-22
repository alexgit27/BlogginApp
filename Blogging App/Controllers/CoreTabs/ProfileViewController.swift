//
//  ProfileViewController.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import UIKit

class ProfileViewController: UIViewController {

	private var user: User?
	
	let currentEmail: String
	
	init(currentEmail: String) {
		self.currentEmail = currentEmail
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let tableView: UITableView = {
		let table = UITableView()
		table.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
		
		return table
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .systemBackground
		setupSignOutButton()
		setupTable()
		title = "Profile"
		fetchPosts()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		tableView.frame = view.bounds
	}
	
	private func setupTable() {
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)
		setupTableHeader()
		fetchProfileData()
	}
	
	private func setupTableHeader(profilePhotoUrl: String? = nil, name: String? = nil) {
		//MARK: HeaderView
		let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width / 1.5))
		headerView.backgroundColor = .systemBlue
		headerView.clipsToBounds = true
		headerView.isUserInteractionEnabled = true
		tableView.tableHeaderView = headerView
		
		//MARK: ProfilePhoto
		let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
		profilePhoto.tintColor = .white
		profilePhoto.contentMode = .scaleAspectFit
		profilePhoto.frame = CGRect(
			x: (view.width - (view.width / 4)) / 2,
			y: (headerView.height - (view.width / 4)) / 2.5,
			width: view.width / 4,
			height: view.width / 4)
		profilePhoto.layer.masksToBounds = true
		profilePhoto.layer.cornerRadius = profilePhoto.width / 2
		profilePhoto.isUserInteractionEnabled = true
		headerView.addSubview(profilePhoto)
		let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
		profilePhoto.addGestureRecognizer(tap)
		
		profilePhoto.backgroundColor = .systemOrange
		//MARK: EmailLabel
		let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom + 10, width: view.width - 40, height: 100))
		emailLabel.text = currentEmail
		emailLabel.textColor = .white
		emailLabel.textAlignment = .center
		emailLabel.font = .systemFont(ofSize: 25, weight: .bold)
		headerView.addSubview(emailLabel)
		
		if let name = name {
			title = name
		}
		
		if let ref = profilePhotoUrl {
			StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
				guard let url = url else { return }
				let task = URLSession.shared.dataTask(with: url) { data, _, _ in
					guard let data = data else { return }
					
					DispatchQueue.main.async {
						profilePhoto.image = UIImage(data: data)
					}
				}
				task.resume()
			}
		}
	}
	
	private func fetchProfileData() {
		DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
			guard let user = user else { return }
			self?.user = user
			
			DispatchQueue.main.async {
				self?.setupTableHeader(profilePhotoUrl: user.profilePictureRef, name: user.name)
			}
		}
	}
	
	private func setupSignOutButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutTapped))
	}
	
	@objc private func didTapProfilePhoto() {
		guard let myEmail = UserDefaults.standard.string(forKey: "email"), currentEmail == myEmail else { return }
		
		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
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
	
	private var posts: [BlogPost] = []
	
	private func fetchPosts() {
		DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
			self?.posts = posts
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
	}
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
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
		
		let vc = ViewPostViewController(post: posts[indexPath.row])
		vc.navigationItem.largeTitleDisplayMode = .never
		vc.title = "Post"
		navigationController?.pushViewController(vc, animated: true)
	}
}

//MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)
		
		guard let image = info[.editedImage] as? UIImage else { return }
		
		StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) { [weak self] success in
			guard let strongSelf = self else { return }
			if success {
				DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in
					guard updated else { return }
					DispatchQueue.main.async {
						strongSelf.fetchProfileData()
					}
				}
			}
		}
	}
}
