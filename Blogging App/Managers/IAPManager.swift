//
//  IAPManager.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import Foundation
import Purchases

//MARK: - App-Specific Shared Secret

///690fa82ae7e340a09225019dedd2d788

//MARK: - App-Specific Shared Secret

//MARK: - Purchases
// premium: alex.Blogging_App.premium

final class IAPMAnager {
	
	static let shared = IAPMAnager()
	
	private init() {}
	
	func isPremium() -> Bool {
		return false
	}
	
	func subscribe() {}
	
	func restorePurchases() {}
	
}

