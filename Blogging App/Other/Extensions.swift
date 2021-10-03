//
//  Extensions.swift
//  Blogging App
//
//  Created by Alexandr on 03.10.2021.
//

import UIKit

extension UIView {
	var width: CGFloat {
		frame.size.width
	}
	
	var height: CGFloat {
		frame.size.height
	}
	
	var left: CGFloat {
		frame.origin.x
	}
	
	var right: CGFloat {
		left + width
	}
	
	var top: CGFloat {
		frame.origin.y
	}
	
	var bottom: CGFloat {
		top + height
	}
}
