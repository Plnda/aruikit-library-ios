//
//  ARViewController.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 29/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import UIKit
import ARKit

/// class will hold all the data to draw an `ARWebView` to the screen
/// - Note: Inherits from ARImage since we need to anchor it from an `ARReferenceImage`
internal class ARController: ARImage {

	// The window we can work with
	private var window: UIWindow!

	// The viewcontroller we are going to display
	private var viewController: UIViewController?

	/// Method will be called after we become active
	override func didBecomeActive() {
		DispatchQueue.main.async { [weak self] in

			self?.window.isUserInteractionEnabled = true
			self?.window.makeKeyAndVisible()
		}
	}

	/// Method will be called after we become inactive
	override func didBecomeInactive() {
		DispatchQueue.main.async { [weak self] in

			self?.window.isUserInteractionEnabled = false
		}
	}

	/// Method will process the `ARWebView`
	override func process() -> SCNNode {

		let plane = SCNPlane(width: 0.6, height: 1.2)
		plane.materials.first?.diffuse.contents = window

		let node = SCNNode(geometry: plane)
		node.name = name
		node.flip()

		return node
	}

	/// A common method that will be called to initialize this class
	private func commonInit(viewController: UIViewController) {
		self.window = UIWindow(frame: CGRect(x: 0, y: 0, width: ARWebView.screenSize.width, height: ARWebView.screenSize.height))

		// Bind the `ViewController` to the rootview
		window.rootViewController = self.viewController
	}

	/// Inits a `ARImage` with a trackable state
	/// - Parameter url: The url we want to show
	/// - Note: To be used to be anchored to a `ARPlane`
	init(viewController: UIViewController) {
		super.init(name: "", width: 0.0)
		commonInit(viewController: viewController)
	}

	/// Inits a `ARImage` with a trackable state
	/// - Parameter name: The name of the image
	/// - Parameter width: The physical width of the image
	/// - Parameter url: The url we want to show
	/// - Note: To be used with the live image detection
	init(name: String, width: CGFloat, viewController: UIViewController) {

		super.init(name: name, width: width)
		commonInit(viewController: viewController)
	}

	required init(name: String, width: CGFloat) {
		super.init(name: name, width: width)
		commonInit(viewController: UIViewController())
	}
}
