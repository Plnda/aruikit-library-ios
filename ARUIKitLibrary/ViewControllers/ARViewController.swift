//
//  ViewController.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 25/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController {

	// Outlets
    @IBOutlet var sceneView: ARSCNView!
	@IBOutlet var surfaceView: UIVisualEffectView!

	// The tracking mechanism we use within our project
	private var trackable: ARUITracking!

    override func viewDidLoad() {
        super.viewDidLoad()

		// Set the correct size
		ARWebView.screenSize = view.bounds.size
		ARController.screenSize = CGSize(width: view.bounds.height, height: view.bounds.width)
		
		let objects = [
			ARController(name: "photo-jason", width: 0.6, viewController: DJBotViewController())
			//ARVideo(name: "photo-jason", width: 0.6)
			//ARWebView(name: "photo-jason", width: 0.6, url: URL(string: "https://pinch.nl")!)
		]

		// Create a new ARUITacking object that tracks the given objects
		trackable = ARUITracking(with: objects, for: sceneView)

		// OnClick will spawn views of the selected type
		trackable.spawnType = ARController.self

		let scene = SCNScene()

        sceneView.delegate = self
        sceneView.scene = scene
		sceneView.session.run(trackable.configuration)

		setUI()
    }

	private func setUI() {

		surfaceView.clipsToBounds = true
		surfaceView.layer.cornerRadius = 10
	}

	private func updateUI() {

		surfaceView.isHidden = !trackable.surfaceDetected
	}
}

extension ARViewController: ARSCNViewDelegate {

	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		trackable.deltaUpdate()

		DispatchQueue.main.async { [weak self] in
			self?.updateUI()
		}
	}

	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		trackable.didAdd(for: node, anchor: anchor)
	}

	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		trackable.didUpdate(for: node, anchor: anchor)
	}

	func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
		trackable.didRemove(node: node, anchor: anchor)
	}
}
