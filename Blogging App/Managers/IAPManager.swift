//
//  IAPManager.swift
//  Blogging App
//
//  Created by Alexandr on 22.07.2021.
//

import Foundation
import Purchases
import StoreKit

//MARK: - App-Specific Shared Secret

///690fa82ae7e340a09225019dedd2d788

//MARK: - App-Specific Shared Secret

//MARK: - Purchases
// premium: alex.Blogging_App.premium

final class IAPMAnager {
	
	static let shared = IAPMAnager()
	
	private init() {}
	
	func isPremium() -> Bool {
		return UserDefaults.standard.bool(forKey: "premium")
	}
	
	public func getSubscriptionStatus(completion: ((Bool) -> Void)?) {
		Purchases.shared.purchaserInfo { info, error in
			guard let entitlements = info?.entitlements, error == nil else { return }
			
			if entitlements.all["Premium"]?.isActive == true {
				print("Get updated status of subscribed!")
				UserDefaults.standard.setValue(true, forKey: "premium")
				completion?(true)
			} else {
				print("Get updated status of Non subscribed!")
				UserDefaults.standard.setValue(false, forKey: "premium")
				completion?(false)
			}
		}
	}
	
	public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) {
		Purchases.shared.offerings { offerings, error in
			guard let package = offerings?.offering(identifier: "default")?.availablePackages.first, error == nil else {
				completion(nil)
				return
			}
			completion(package)
			
		}
	}
	
	public func subscribe(package: Purchases.Package, completion: @escaping(Bool) -> Void) {
		guard !isPremium() else {
			print("User already subscribe!")
			completion(true)
			return
		}
		
		Purchases.shared.purchasePackage(package) { transaction, info, error, userCanceled in
			guard let transaction = transaction, let entitlements = info?.entitlements, error == nil, !userCanceled else { return }
			
			switch transaction.transactionState {
			case .purchasing:
				print("Purchasing")
			case .purchased:
				if entitlements.all["Premium"]?.isActive == true {
					print("Purchased!")
					UserDefaults.standard.setValue(true, forKey: "premium")
					completion(true)
				} else {
					print("Purchases failed!")
					UserDefaults.standard.setValue(false, forKey: "premium")
					completion(false)
				}
			case .failed:
				print("Failed")
			case .restored:
				print("Restored")
			case .deferred:
				print("Deferred")
			@unknown default:
				print("Default")
			}
		}
	}
	
	public func restorePurchases(completion: @escaping(Bool) -> Void) {
		Purchases.shared.restoreTransactions { info, error in
			guard let entitlements = info?.entitlements, error == nil else { return }
			
			if entitlements.all["Premium"]?.isActive == true {
				print("Restore Sucsess")
				UserDefaults.standard.setValue(true, forKey: "premium")
				completion(true)
			} else {
				print("Restore Failed")
				UserDefaults.standard.setValue(false, forKey: "premium")
				completion(false)
			}
		}
	}
	
}

