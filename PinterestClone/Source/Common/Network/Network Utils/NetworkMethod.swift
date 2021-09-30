//
//  NetworkMethod.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation

enum NetworkMethod: String {
    case POST
    case GET
    case PUT
    case DELETE
}

enum ParameterType {
    case none
    case params
    case body
}
