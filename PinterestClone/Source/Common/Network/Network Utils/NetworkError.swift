//
//  NetworkError.swift
//  PinterestClone
//
//  Created by SonHoang on 12/3/20.
//

import Foundation

enum NetworkError {
    case badURL
    
    var error: NSError {
        switch self {
        case .badURL:
            return NSError(domain: "Bad URL", code: 666, userInfo: [:])
        }
    }
    
}
