//
//  ARPlaneAnchor.swift
//  Screens
//
//  Created by Jason Meulenhoff on 20/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import ARKit

extension ARPlaneAnchor {

	/// Returns a `SCNVector3` from the center of this `ARPlaneAnchor`
	var centerVector: SCNVector3 {
		return SCNVector3(CGFloat(center.x), CGFloat(center.y), CGFloat(center.z))
	}

	/// Creates a basic node with a plane
	/// - Parameters:
	/// - Parameter color: The color we want to give this plane
	/// - Note: Defaults to the color `UIColor.lightGray`
	func createNode(color: UIColor = .lightGray) -> SCNNode {

		let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
		plane.materials.first?.diffuse.contents = color

		let node = SCNNode(geometry: plane)

		node.position = centerVector
		node.flip()

		return node
	}

	/// Updates a node and its child plane
	/// - Parameters:
	/// - Parameter root: The root node we want altered
	func updateNode(root: SCNNode) {

		guard let node = root.childNodes.first, let plane = node.geometry as? SCNPlane else {
			return
		}

		plane.width = CGFloat(extent.x)
		plane.height = CGFloat(extent.z)

		node.position = centerVector
	}
}
