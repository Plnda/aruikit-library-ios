//
//  EmbedViewController.swift
//  NewsPaper
//
//  Created by Jason Meulenhoff on 25/06/2018.
//  Copyright © 2018 Jason Meulenhoff. All rights reserved.
//

import UIKit
import WebKit

class ARWebViewController: UIViewController {

	internal var url: URL!

	@IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .clear
		webView.loadRequest(URLRequest(url: url))
    }
}

