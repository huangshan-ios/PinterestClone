//
//  CollectionsService.swift
//  PinterestClone
//
//  Created by SonHoang on 12/4/20.
//

import Foundation
import Combine

protocol CollectionsServiceType {
    func fetchCollections(page: Int, itemPerPage: Int) -> AnyPublisher<[ImageCollection], Error>
}

struct CollectionsService: CollectionsServiceType {
        
    func fetchCollections(page: Int, itemPerPage: Int) -> AnyPublisher<[ImageCollection], Error> {
        return provider.requestAPI(.collections(page, itemPerPage))
            .tryMap { (data, response) -> [ImageCollection] in
                do {
                    let collections = try JSONDecoder().decode([ImageCollection].self, from: data)
                    return collections
                } catch let error {
                    throw error
                }
            }.eraseToAnyPublisher()
    }
}
