//
//  Track.swift
//  ARUIKitLibrary
//
//  Created by Joost Weterings on 06/07/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation

struct Track: Decodable, Equatable {

	let artist: String
	let title: String
	let albumArtURL: URL?
	let duration: Int?

	enum CodingKeys: String, CodingKey {
		case artist
		case title
		case albumArtURL = "absoluteAlbumArtUri"
		case duration
	}
}
