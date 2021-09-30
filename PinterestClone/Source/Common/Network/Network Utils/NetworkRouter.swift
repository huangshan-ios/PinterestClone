//
//  NetworkRouter.swift
//  PinterestClone
//
//  Created by SonHoang on 12/4/20.
//

import Foundation

protocol Router {
    var baseURL: URL { get }
    var method: NetworkMethod { get }
    var parameterType: ParameterType { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var path: String { get }
}

enum NetworkRouter {
    case collections(Int, Int)
}

extension NetworkRouter: Router {
    
    var baseURL: URL {
        return URL(string: AppConstant.baseURL)!
    }
    
    var method: NetworkMethod {
        switch self {
        case .collections:
            return .GET
        }
    }
    
    var parameterType: ParameterType {
        switch self {
        case .collections:
            return .params
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .collections(let page, let itemPerPage):
            return ["page": page, "per_page": itemPerPage]
        }
    }
    
    var headers: [String: String]? {
        return [
            "Authorization": "Client-ID \(AppConstant.ACCESS_KEY)"
        ]
    }
    
    var path: String {
        switch self {
        case .collections:
            return "/collections"
        }
    }
}
