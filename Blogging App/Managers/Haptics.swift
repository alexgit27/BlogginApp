//
//  Haptics.swift
//  Blogging App
//
//  Created by Alexandr on 22.10.2021.
//

import UIKit

class Haptics {
	static let shared = Haptics()
	
	private init() {}
	
	func vibrateForSelection() {
		let generator = UISelectionFeedbackGenerator()
		generator.prepare()
		generator.selectionChanged()
	}
	
	func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
		let generator = UINotificationFeedbackGenerator()
		generator.prepare()
		generator.notificationOccurred(type)
	}
}
