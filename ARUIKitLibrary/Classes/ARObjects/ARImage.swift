//
//  ARImage.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 28/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import UIKit
import ARKit

/// A Simple class that holds the meta data to recognize an image in the scene
class ARImage: ARObject {

	// The size of the screen
	public static var screenSize: CGSize = .zero

	/// Name of the image we want to detect
	var name: String

	/// The physical width of the image we are trying to detect in `meters`
	var width: CGFloat

	/// Tracking state of the object defaults to `untracked`
	var trackingState: TrackingState = .untracked

	/// Stub
	func process() -> SCNNode {
		assertionFailure("This method cannot be called, subclass it")
		return SCNNode()
	}

	/// Stub
	func didBecomeActive() {
		assertionFailure("This method cannot be called, subclass it")
	}

	/// Stub
	func didBecomeInactive() {
		assertionFailure("This method cannot be called, subclass it")
	}

	/// Inits a `ARImage` with the supplied data
	/// - Parameters:
	/// - Parameter name: The name of the image
	/// - Parameter width: The physical width of the image
	required init(name: String, width: CGFloat) {

		self.name = name
		self.width = width
	}
}
