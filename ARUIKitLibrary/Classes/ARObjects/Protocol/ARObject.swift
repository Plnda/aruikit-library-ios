//
//  ARObject.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 26/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import UIKit
import ARKit

// The state of the current image
enum TrackingState {
	case tracked
	case untracked
}

internal protocol ARObject: class {

	/// Name of the object
	var name: String { get set}

	/// The actual tracking state of the `ARObject`
	var trackingState: TrackingState { get set }

	/// Will process and return a node
	func process() -> SCNNode

	/// Method will be called after we become active
	func didBecomeActive()

	/// Method will be called after we become inactive
	func didBecomeInactive()
}
