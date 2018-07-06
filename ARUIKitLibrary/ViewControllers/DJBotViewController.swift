//
//  DJBotViewController.swift
//  ARUIKitLibrary
//
//  Created by Joost Weterings on 06/07/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage

final class DJBotViewController: UIViewController {

	// API
	let api = API()

	// UI
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!

	// Dispose bag
	private let disposeBag = DisposeBag()

	static func instance() -> DJBotViewController {
		return UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DJBotViewController") as! DJBotViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		api.getPlayingQueue()
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [weak self] (queue) in

				self?.imageView.af_setImage(withURL: queue.currentTrack.albumArtURL, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
				self?.titleLabel.text = queue.currentTrack.title
				self?.subtitleLabel.text = queue.currentTrack.artist

			}) { (error) in

				print(error.localizedDescription)

			}
			.disposed(by: disposeBag)
	}
}
