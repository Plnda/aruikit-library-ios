//
//  API.swift
//  ARUIKitLibrary
//
//  Created by Joost Weterings on 06/07/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation

final class API {

	func getNowPlaying() {

		let url = URL(string: "http://192.168.2.106:5005/office/state/")!

		let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in

			guard let data = data else { return }
			do {

				let page = try JSONDecoder().decode(String.self, from: data)

			} catch (let error) {
				print(error.localizedDescription)
			}
		}

		task.resume()
	}
}
