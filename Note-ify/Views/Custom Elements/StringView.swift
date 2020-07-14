//
//  StringView.swift
//  Note-ify
//
//  Created by Jonas Gamburg on 13/07/2020.
//  Copyright © 2020 Jonas Gamburg. All rights reserved.
//

import UIKit

class StringView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .white
        layer.borderWidth = 0
    }
}
