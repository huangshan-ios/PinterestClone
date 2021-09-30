//
//  UIButton+Extensions.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation
import UIKit

extension UIButton {
    var tapPublisher: EventPublisher {
        publisher(for: .touchUpInside)
    }
}
