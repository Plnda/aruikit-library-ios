//
//  ARImageAnchor.swift
//  Screens
//
//  Created by Jason Meulenhoff on 22/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import ARKit
import UIKit

extension ARImageAnchor {

	/// Returns the `ARImageAnchor` position in a `SCNVector3`
	var position: SCNVector3 {
		return SCNVector3(CGFloat(transform.columns.3.x), CGFloat(transform.columns.3.y), CGFloat(transform.columns.3.z))
	}

	/// Creates a basic node with a plane
	/// - Parameters:
	/// - Parameter color: The color we want to give this plane
	/// - Note: Defaults to the color `UIColor.lightGray`
	func createNode(width: Float, height: Float, color: UIColor = .lightGray) -> SCNNode {

		let plane = SCNPlane(width: CGFloat(width), height: CGFloat(height))
		plane.materials.first?.diffuse.contents = color

		let node = SCNNode(geometry: plane)
		node.flip()

		return node
	}

	func addTextNode(text: String, color: UIColor = UIColor.white, position: SCNVector3) -> SCNNode {

		let text = SCNText(string: text, extrusionDepth: 0)
		let font = UIFont(name: "Arial", size: 1)

		text.font = font
		text.containerFrame = CGRect(x: 0, y: 0, width: 200, height: 100)
		text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
		text.firstMaterial?.diffuse.contents = color
		text.firstMaterial?.specular.contents = color
		text.firstMaterial?.isDoubleSided = true

		let (minBound, maxBound) = text.boundingBox
		let textNode = SCNNode(geometry: text)

		textNode.flip()
		textNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, 0.02/2)
		textNode.scale = SCNVector3Make(0.01, 0.01, 0.01)
		textNode.position = position

		return textNode
	}
}
