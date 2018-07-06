//
//  ARTracking.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 26/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import ARKit

internal protocol ARUITrackingDelegate: class {

	// Will trigger whenever a `ARImage` was tracked
	var trackedAction: SCNAction { get }

	// Will trigger whenever a `ARImage` was untracked
	var untrackedAction: SCNAction { get }
}

/// Class will handle all of the tracking for you
internal class ARUITracking {

	/// Holds the interal configuration we are using for ar
	internal let configuration = ARWorldTrackingConfiguration.default

	/// The object that will be spawned when we actually tap the screen
	internal var spawnType: ARImage.Type?

	/// Returns if a surface was detected
	internal var surfaceDetected: Bool {
		return surfaceCount > 0
	}

	/// Holds how many surfaces we have detected
	private var surfaceCount: Int = 0

	/// Holds all the objects that have been spawned through hits
	private var spawnedObjects: [String : ARObject] = [:]

	/// Holds the internal objects we want to track
	private var objects: [ARImage]!

	/// The scene we want to monitor
	private var scene: ARSCNView!

	/// Inits the tracking object with the given `ARObject`
	/// - Parameter objects: A struct of objects we want to track
	init(with objects: [ARImage], for scene: ARSCNView) {

		self.objects = objects
		self.scene = scene

		// Create reference images for the configuration
		configuration.detectionImages = Set<ARReferenceImage>(self.objects.compactMap({ loadReferenceImage(named: $0.name, width: $0.width) }))
		configuration.maximumNumberOfTrackedImages = self.objects.count

		// Add our hit tester
		scene.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:))))
	}

	/// Spawns a ARObject that is supported by this framework
	/// - Parameter anchor: The anchor attached to the node
	/// - Parameter type: The type of `ARObject` we want to spawn
	private func spawnARObject(anchor: ARAnchor, type: ARImage.Type) -> ARObject? {

		let uniqueName = "\(anchor.identifier)-\(NSUUID())"

		if type is ARVideo.Type {
			return ARVideo(name: uniqueName, width: 0.0)
		}

		if type is ARWebView.Type {
			return ARWebView(name: uniqueName, width: 0.0, url: URL(string: "https://pinch.nl")!)
		}

		if type is ARController.Type {
			return ARController(name: uniqueName, width: 0.0, viewController: DJBotViewController())
		}

		return nil
	}

	/// Method will handle the hit functionality within our ARUITracking scene
	/// - Parameter gesture: The `UITapGesture` that triggerd this method
	@objc private func handleTap(gesture: UITapGestureRecognizer) {

		/// - TODO: Find out how we can detect taps on a spawned `ARObject`
		
		let results = scene.hitTest(gesture.location(in: scene), types: .existingPlane)

		// Get the anchor and the node if present
		if let result = results.first, let anchor = result.anchor, let node = scene.node(for: anchor) {

			// Check if we have a object set
			guard let type = spawnType, let object = spawnARObject(anchor: anchor, type: type) else  {
				return
			}

			// Create a child node and set its position
			let childNode = object.process()
			childNode.position = result.position

			// Add it to the list of objects we keep track off (we always set the name)
			spawnedObjects[childNode.name!] = object

			// Add it as child node
			node.addChildNode(childNode)
		}
	}

	/// Loads the a reference image into memory, and make it trackable
	/// - Parameters:
	/// - Parameter name: The name of the image
	/// - Parameter width: The physical width of the image
	/// - Note: The name of the reference image will be the same name as the image name
	private func loadReferenceImage(named name: String, width: CGFloat) -> ARReferenceImage? {

		guard let image = UIImage(named: name)?.cgImage else {
			print("couldn't load the image")
			return nil
		}

		let referenceImage = ARReferenceImage(image, orientation: .up, physicalWidth: width)
		referenceImage.name = name

		return referenceImage
	}

	/// Method will add childNodes to the node so we can display our content
	/// - Parameters:
	/// - Parameter node: The node that was added in the scene
	/// - Parameter anchor: The anchor that was detected
	internal func didAdd(for node: SCNNode, anchor: ARAnchor) {

		// Check if we have a plane and create a plane
		if let anchor = anchor as? ARPlaneAnchor {
			node.addChildNode(anchor.createNode(color: .clear))
			surfaceCount += 1
			return
		}

		// Did we detect our image
		guard
			let anchor = anchor as? ARImageAnchor,
			let object = self.objects.filter({$0.name == anchor.referenceImage.name }).first
		else {
			return
		}

		let childNode = object.process()

		node.addChildNode(childNode)
		node.opacity = 0
	}

	/// Method did update a node, we should change our tracking status
	/// - Parameters:
	/// - Parameter node: The node that was added in the scene
	/// - Parameter anchor: The anchor that was detected
	internal func didUpdate(for node: SCNNode, anchor: ARAnchor) {

		// Check if we have a plane and update accordingly
		if let anchor = anchor as? ARPlaneAnchor {
			anchor.updateNode(root: node)
			return
		}

		// Filter out what we need to update
		guard
			let anchor = anchor as? ARImageAnchor,
			let object = self.objects.filter({$0.name == anchor.referenceImage.name }).first,
			configuration.detectionImages.count > 0
		else {
			return
		}

		// We have a dissapearing `ARImage`
		if object.trackingState == .tracked && !anchor.isTracked {
			node.runAction(untrackedAction, completionHandler: {
				object.didBecomeInactive()
			})

			object.trackingState = .untracked
		}

		// We have an appearing `ARImage`
		if object.trackingState == .untracked && anchor.isTracked {
			node.runAction(trackedAction, completionHandler: {
				object.didBecomeActive()
			})

			object.trackingState = .tracked
		}
	}

	/// Method will be called when we delete a node from the world
	/// - Parameter node: The node that is removed from the scene
	internal func didRemove(node: SCNNode, anchor: ARAnchor) {

		// Equalize the count if a anchor was removed
		if let _ = anchor as? ARPlaneAnchor {
			surfaceCount -= 1
		}

		node.removeAllActions()
		node.removeChildNodes()
	}

	/// Method will update object state with objects that are in view
	internal func deltaUpdate() {

		// Check if the camera is visible
		if let camera = scene.pointOfView {

			// The nodes that are currently visible
			let nodes = scene.nodesInsideFrustum(of: camera).filter({$0.name != nil })

			// Gather all the objects in the scene
			let objectsInScene = spawnedObjects.map({$0.value})

			// Find visible objects that are not tracked yet
			let objectsInCamera = objectsInScene.filter({ object in nodes.contains(where: { node in node.name == object.name }) && object.trackingState == .untracked })

			// Find non visible objects that are still trackes
			let objectsOffCamera = objectsInScene.filter({ object in !nodes.contains(where: { node in node.name == object.name }) && object.trackingState == .tracked })

			// Untracked objects in camera view
			objectsInCamera.forEach({
				$0.didBecomeActive()
				$0.trackingState = .tracked
			})

			// Tracked objects outside camera view
			objectsOffCamera.forEach({
				$0.didBecomeInactive()
				$0.trackingState = .untracked
			})
		}
	}
}

/// Mark: ARUITrackingDelegate
extension ARUITracking: ARUITrackingDelegate {

	var trackedAction: SCNAction {
		return SCNAction.fadeIn(duration: 0.5)
	}

	var untrackedAction: SCNAction {
		return SCNAction.fadeOut(duration: 0)
	}
}
