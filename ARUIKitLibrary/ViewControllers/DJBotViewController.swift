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

	// Queue
	let localQueue = BehaviorSubject<Queue?>(value: nil)

	// Current cover
	let localAlbumArtURL = BehaviorSubject<URL?>(value: nil)

	// UI
	@IBOutlet weak var maskCurrentTrackImageView: UIImageView!
	@IBOutlet weak var currentTrackImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var progressSlider: UISlider!
	@IBOutlet weak var elapsedTimeLabel: UILabel!
	@IBOutlet weak var durationLabel: UILabel!

	// Dispose bags
	private var disposeBag = DisposeBag()
	private var requestDisposeBag = DisposeBag()

	static func instance() -> DJBotViewController {
		return UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DJBotViewController") as! DJBotViewController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		maskCurrentTrackImageView.animationImages = []

		for i in 0...335 {
			let imageName = "audio-circle_\(String(format: "%05d", i))"
			let image = UIImage(named: imageName)!
			maskCurrentTrackImageView.animationImages?.append(image)
		}

		maskCurrentTrackImageView.startAnimating()

		poll().subscribe().disposed(by: requestDisposeBag)

		bindObservables()
	}

	func poll() -> Single<Queue> {

		return api.getPlayingQueue()
			.do(onSuccess: { [weak self] (queue) in

				self?.localQueue.onNext(queue)
				self?.localAlbumArtURL.onNext(queue.currentTrack.albumArtURL)

			})

	}

	private func bindObservables() {

		localQueue.asObserver()
			.observeOn(MainScheduler.instance)
			.distinctUntilChanged()
			.subscribe(onNext: { [weak self] (queue) in

				guard let queue = queue else { return }

				self?.titleLabel.text = queue.currentTrack.title
				self?.subtitleLabel.text = queue.currentTrack.artist
				self?.elapsedTimeLabel.text = queue.elapsedTime.toTimeParts().description
				self?.durationLabel.text = queue.currentTrack.duration.toTimeParts().description
				self?.progressSlider.value = Float(queue.elapsedTime) / Float(queue.currentTrack.duration)

			})
			.disposed(by: disposeBag)

		localAlbumArtURL.asObserver()
			.observeOn(MainScheduler.instance)
			.distinctUntilChanged()
			.subscribe(onNext: { [weak self] (url) in

				guard let url = url else { return }

				self?.currentTrackImageView.image = nil
				self?.currentTrackImageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)

			})
			.disposed(by: disposeBag)

		let _ = Observable<Int>
			.interval(1, scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self, requestDisposeBag = requestDisposeBag] int in

				self?.requestDisposeBag = DisposeBag()
				self?.poll().subscribe().disposed(by: requestDisposeBag)

			})
			.disposed(by: disposeBag)
	}
}
