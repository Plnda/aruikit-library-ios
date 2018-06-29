//
//  ARVideo.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 26/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import ARKit

internal class ARVideo: ARImage {

	private var player = AVPlayer(url: URL(string: "https://clips.vorwaerts-gmbh.de/VfE_html5.mp4")!)
	private var videoNode: SKVideoNode!

	override func process() -> SCNNode {

		let scene = SKScene(size: CGSize(width: 640, height: 320))

		videoNode = SKVideoNode(avPlayer: player)
		videoNode.position = CGPoint(x: scene.size.width/2, y: scene.size.height/2)
		videoNode.size = scene.size
		videoNode.yScale = -1

		scene.addChild(videoNode)

		let plane = SCNPlane(width: 1.5, height: 0.8)
		plane.firstMaterial?.diffuse.contents = scene

		let node = SCNNode(geometry: plane)
		node.name = name
		node.flip()

		return node
	}

	override func didBecomeActive() {
		videoNode.play()
	}

	override func didBecomeInactive() {
		videoNode.pause()
	}
}
