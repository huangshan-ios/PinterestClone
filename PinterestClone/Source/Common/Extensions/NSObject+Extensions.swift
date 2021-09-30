//
//  NSObject+Extensions.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation

extension NSObject {
    @nonobjc class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    var className: String {
        return type(of: self).className
    }
}
