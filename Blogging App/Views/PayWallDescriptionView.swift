//
//  PayWallDescriptionLabel.swift
//  Blogging App
//
//  Created by Alexandr on 03.10.2021.
//

import UIKit

class PayWallDescriptionView: UIView {

	private let descriptorLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 26, weight: .medium)
		label.text = "Join Thoughts Premium to read unlimited articles and browse thousandsof posts."
		label.numberOfLines = 0
		
		return label
	}()
	
	private let priceLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 22, weight: .regular)
		label.text = "£9.99 month"
		label.numberOfLines = 1
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		clipsToBounds = true
		addSubview(priceLabel)
		addSubview(descriptorLabel)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		descriptorLabel.frame = CGRect(x: 20, y: 0, width: width - 40, height: height / 2)
		priceLabel.frame = CGRect(x: 20, y: height / 2, width: width - 40, height: height / 2)
	}
}
