//
//  Publisher+Extensions.swift
//  PinterestClone
//
//  Created by SonHoang on 12/4/20.
//

import Foundation
import Combine

extension Publisher {
    func unwrapOrFail<Wrapped>(with error: Failure) -> Publishers.FlatMap<Result<Wrapped, Self.Failure>.Publisher, Self> where Output == Wrapped? {
        return self.flatMap ({ $0.map { Result.success($0).publisher } ?? Result.failure(error).publisher })
    }
}
