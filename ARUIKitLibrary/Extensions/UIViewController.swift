//
//  UIViewController.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 26/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

	/// Creates a new instance of the UIViewController, initialized from a storyboard with the same name.
	internal static func newInstance() -> Self {
		return newInstanceHelper()
	}

	private static func newInstanceHelper<T: UIViewController>() -> T {

		let bundle = Bundle.main
		let storyboardName = String(describing: T.self)
		let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
		guard let result = storyboard.instantiateInitialViewController() as? T else {
			fatalError("Could not instantiate initial view controller.")
		}

		return result
	}
}
