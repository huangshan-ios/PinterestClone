//
//  ActionSubject.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation
import Combine

class ActionSubject<Output, Failure: Error>: Subject {
    
    private let wrapped = PassthroughSubject<Output, Failure>()
    
    func send(_ value: Output) {
        wrapped.send(value)
    }

    func send(completion: Subscribers.Completion<Failure>) {
        wrapped.send(completion: completion)
    }

    func send(subscription: Subscription) {
        wrapped.send(subscription: subscription)
    }

    func receive<Downstream: Subscriber>(subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input {
        wrapped.subscribe(subscriber)
    }
   
    deinit {
        wrapped.send(completion: .finished)
    }
    
}
