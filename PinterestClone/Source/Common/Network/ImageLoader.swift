//
//  ImageLoader.swift
//  PinterestClone
//
//  Created by SonHoang on 3/1/21.
//

import Foundation
import UIKit
import Combine

class ImageLoader {

    private let urlSession: URLSession
    private let cache: NSCache<NSURL, UIImage>

    init(urlSession: URLSession = .shared,
         cache: NSCache<NSURL, UIImage> = .init()) {
        self.urlSession = urlSession
        self.cache = cache
    }

    func publisher(for url: URL) -> AnyPublisher<UIImage, Error> {
        if let image = cache.object(forKey: url as NSURL) {
            return Just(image)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return urlSession
                .dataTaskPublisher(for: url)
                .map(\.data)
                .tryMap { data in
                    guard let image = UIImage(data: data) else {
                        throw URLError(.badServerResponse, userInfo: [
                            NSURLErrorFailingURLErrorKey: url
                        ])
                    }
                    return image
                }
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { [cache] image in
                    cache.setObject(image, forKey: url as NSURL)
                })
                .eraseToAnyPublisher()
        }
    }
}
