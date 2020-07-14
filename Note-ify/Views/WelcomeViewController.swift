//
//  WelcomeViewController.swift
//  Note-ify
//
//  Created by Jonas Gamburg on 13/07/2020.
//  Copyright © 2020 Jonas Gamburg. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var notesImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var donateButton: CustomButton!
    @IBOutlet weak var startButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp() {
        view.backgroundColor = Colors.backgroundColor
        setUpButtons()
        setUpLabels()
    }
    
    func setUpLabels() {
        mainTitleLabel.textColor = .white
        messageLabel.textColor   = .white
    }

    
    func setUpButtons() {
        donateButton.setUp(as: .donate)
        startButton.setUp(as: .start)
    }
}
