//
//  CustomButton.swift
//  Note-ify
//
//  Created by Jonas Gamburg on 13/07/2020.
//  Copyright © 2020 Jonas Gamburg. All rights reserved.
//

import UIKit

enum CustomButtonType {
    case start
    case donate
    case help
}

class CustomButton: UIButton {
    
    var hasShadow: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUp(withFont fontName: String, size: CGFloat, and title: String) {
        self.titleLabel?.font = UIFont(name: fontName, size: size)
    }
    
    func setUp(as buttonType: CustomButtonType) {
        switch buttonType {
        case .start: startButton()
        case .donate: donateButton()
        case .help: helpButton()
        }
    }
    
    func startButton() {
        setUp(withType: .start)
    }
    
    func donateButton() {
        setUp(withType: .donate)
    }
    
    func helpButton() {
        setUp(withType: .help)
    }
}

extension CustomButton {
    private func setUp(withType type: CustomButtonType) {
        switch type {
        case .start:
            backgroundColor = Colors.startButtonColor
            titleLabel?.font = UIFont(name: General.appFont, size: 28)
            configureVisualElements()
            
        case .donate:
            backgroundColor = Colors.donateButtonColor
            titleLabel?.font = UIFont(name: General.appFont, size: 24)
            configureVisualElements()
            
        case .help:
            titleLabel?.font = UIFont(name: General.appFont, size: 20)
            configureVisualElements()
        }
    }
    
    private func configureVisualElements() {
        tintColor = .white
        setUpShape()
        setUpShadow()
    }
    
    private func setUpShape() {
        layer.cornerRadius = frame.height / 2
    }
    
    private func setUpShadow() {
        if hasShadow {
            layer.borderColor   = UIColor.clear.cgColor
            layer.shadowColor   = UIColor.black.cgColor
            layer.shadowOffset  = .init(width: 0, height: 7)
            layer.shadowRadius  = 12
            layer.shadowOpacity = 0.4
            clipsToBounds       = true
            layer.masksToBounds = false
            
        } else { print("CustomButton: Shadow is disabled.") }
    }
}
