//
//  ARWorldTrackingConfiguration.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 26/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import ARKit

extension ARWorldTrackingConfiguration {

	/// Returns a default tracking session, we normally use within ARKit
	static var `default`: ARWorldTrackingConfiguration {

		let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .vertical
		configuration.isAutoFocusEnabled = true
		configuration.isLightEstimationEnabled = true
		configuration.environmentTexturing = .automatic

		return configuration
	}

}
