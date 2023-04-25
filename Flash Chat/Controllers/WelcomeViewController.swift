//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLbl = "⚡️FlashChat"
        var indexTime = 0
        titleLabel.text = ""
        for it in titleLbl {
            Timer.scheduledTimer(withTimeInterval: 0.1 * Double(indexTime), repeats: false) { timer in
                print(String(it))
                self.titleLabel.text?.append(it)
            }
            indexTime += 1
        }
    }
}
