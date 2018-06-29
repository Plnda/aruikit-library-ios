//
//  SceneNode.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 25/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import ARKit

extension SCNNode {

	/// Flips the node so it will lay flat on the surface
	func flip() {
		eulerAngles.x = -.pi / 2
	}

	/// Method removes the child nodes from memory
	func removeChildNodes() {
		enumerateChildNodes { (node, _) in
			node.removeAllActions()
			node.removeFromParentNode()
		}
	}
}
