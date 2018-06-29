//
//  ARHitTestResult.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 28/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import ARKit

extension ARHitTestResult {

	/// Returns the position of the tapped location
	var position: SCNVector3 {
		return SCNVector3(x: worldTransform.columns.3.x, y: worldTransform.columns.3.y, z: worldTransform.columns.3.z)
	}
}
