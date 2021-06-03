//
//  FontAwesome.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 26/05/21.
//

import Foundation
import UIKit

class FontAwesomeConverter {

    public static func image(fromChar char: String,
                             color: UIColor,
                             size: CGFloat) -> UIImage {
        // 1.
        let label = UILabel(frame: .zero)
        label.textColor = color
        label.font = UIFont(name: "Font Awesome 5 Free", size: size)
        label.text = char
        // 2.
        label.sizeToFit()

        // 3.
        let renderer = UIGraphicsImageRenderer(size: label.frame.size)

        // 4.
        let image = renderer.image(actions: { context in
            // 5.
            label.layer.render(in: context.cgContext)
        })

        return image
    }
}
