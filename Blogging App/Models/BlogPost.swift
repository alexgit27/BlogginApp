//
//  BlogPost.swift
//  Blogging App
//
//  Created by Alexandr on 02.10.2021.
//

import Foundation

struct BlogPost {
	let identifier: String
	let title: String
	let timestamp: TimeInterval
	let headerImageUrl: URL?
	let text: String
}
