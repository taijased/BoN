//
//  InfoViewController.swift
//  BoltAPI
//
//  Created by Maxim Spiridonov on 19/06/2019.
//  Copyright © 2019 Maxim Spiridonov. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, StoryboardInitializable {

    @IBAction func closeButton(_ sender: UIButton) {
        sender.flash()
        dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
