//
//  ImageCollectionItem.swift
//  PinterestClone
//
//  Created by SonHoang on 3/1/21.
//

import Foundation
import UIKit

enum Section: Int {
    case main
}

struct ImageCollectionItem: Hashable {
    let id: String
    let title: String
    let coverImageURL: String
    let imageSize: CGSize
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (left: ImageCollectionItem, right: ImageCollectionItem) -> Bool {
        left.id == right.id
    }
}
