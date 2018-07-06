//
//  API.swift
//  ARUIKitLibrary
//
//  Created by Joost Weterings on 06/07/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import Foundation
import RxSwift

final class API {

	func getPlayingQueue() -> Single<Queue> {

		let url = URL(string: "http://192.168.2.106:7777/v1/state/")!

		return Single.create(subscribe: { (single) -> Disposable in

			let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

				guard let data = data else { return }
				do {

					let queue = try JSONDecoder().decode(Queue.self, from: data)
					single(.success(queue))

				} catch (let error) {
					single(.error(error))
				}
			}

			task.resume()

			return Disposables.create {
				task.cancel()
			}

		})
	}
}
