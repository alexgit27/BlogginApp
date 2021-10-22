//
//  CreateNewPostViewController.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import UIKit

class CreateNewPostViewController: UIViewController {

	private let titleField: UITextField = {
		let field = UITextField()
		field.autocapitalizationType = .words
		field.autocorrectionType = .yes
		field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
		field.leftView?.backgroundColor = .red
		field.leftViewMode = .always
		field.placeholder = "Enter Title"
		field.backgroundColor = .secondarySystemBackground
		field.layer.masksToBounds = true

		return field
	}()

	private let headerImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.isUserInteractionEnabled = true
		imageView.image = UIImage(systemName: "photo")
		imageView.backgroundColor = .orange
//			.tertiarySystemBackground

		return imageView
	}()

	private let textView: UITextView = {
		let textView = UITextView()
		textView.backgroundColor = .secondarySystemBackground
		textView.isEditable = true
		textView.font = .systemFont(ofSize: 28)

		return textView
	}()

	private var selectedHeaderImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .systemBackground
		view.addSubview(titleField)
		view.addSubview(headerImageView)
		view.addSubview(textView)
		let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
		headerImageView.addGestureRecognizer(tap)
		configureButtons()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width - 20, height: 50)
		headerImageView.frame = CGRect(x: 0, y: titleField.bottom + 5, width: view.width, height: 160)
		textView.frame = CGRect(x: 10, y: headerImageView.bottom + 10, width: view.width - 20, height: view.height - 210 - view.safeAreaInsets.top)
	}

	private func configureButtons() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
	}

	@objc private func didTapHeader() {
			let picker = UIImagePickerController()
			picker.sourceType = .photoLibrary
			picker.delegate = self
			present(picker, animated: true, completion: nil)
	}

	@objc private func didTapCancel() {
		dismiss(animated: true, completion: nil)
	}

	@objc private func didTapPost() {
		guard let title = titleField.text,
			  let body = textView.text,
			  let headerImage = selectedHeaderImage,
			  let email = UserDefaults.standard.string(forKey: "email"),
			  !title.trimmingCharacters(in: .whitespaces).isEmpty,
			  !body.trimmingCharacters(in: .whitespaces).isEmpty else {
				  let alert = UIAlertController(title: "Enter Post Details!", message: "Please enter a title, body and select a image to continue!", preferredStyle: .alert)
				  alert.addAction(.init(title: "OK", style: .default, handler: nil))
				  present(alert, animated: true, completion: nil)
				  return }
		
		let newPostId = UUID().uuidString
		
		StorageManager.shared.uploadBlogHeaderImage(email: email, image: headerImage, postId: newPostId) { success in
			guard success else { return }
			
			StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newPostId) { url in
				guard let headerUrl = url else {
					DispatchQueue.main.async { Haptics.shared.vibrate(for: .error) }
					return
				}
				
				let post = BlogPost(identifier: newPostId,
									title: title,
									timestamp: Date().timeIntervalSince1970,
									headerImageUrl: headerUrl,
									text: body)
				
				DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] posted in
					guard posted else {
						DispatchQueue.main.async { Haptics.shared.vibrate(for: .error) }
						return
					}
					
					DispatchQueue.main.async {
						Haptics.shared.vibrate(for: .success)
						self?.didTapCancel()
					}
				}
			}
		}
	}
}

// MARK: - UIImagePickerControllerDelegate , UINavigationControllerDelegate
extension CreateNewPostViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)
		guard let image = info[.originalImage] as? UIImage else { return }
		selectedHeaderImage = image
		headerImageView.image = image
	}
}
