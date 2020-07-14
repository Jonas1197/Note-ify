//
//  Extensions.swift
//  Note-ify
//
//  Created by Jonas Gamburg on 13/07/2020.
//  Copyright © 2020 Jonas Gamburg. All rights reserved.
//

import UIKit

public extension UIView {

    func shake(count: Float = 4, for duration: TimeInterval = 0.5, withTranslation translation: Float = 5) {
        UIView.animate(withDuration:duration, delay: 0.0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            animation.repeatCount = count
            animation.duration = duration/TimeInterval(animation.repeatCount)
            animation.autoreverses = true
            animation.values = [translation, -translation]
            self.layer.add(animation, forKey: "shake")
        }, completion: nil)
        
    }
}
