//
//  CollectionsViewModel.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation
import Combine
import UIKit

class CollectionsViewModel: ViewModelType {
    
    private var bag = Set<AnyCancellable>()
    
    @Published private(set) var state = State.idle
    
    private let input = PassthroughSubject<Event, Never>()
    
    enum Event {
        case refreshCollections
        case loadMoreCollections(Int)
        case loadedCollections([ImageCollection])
        case error(Error)
        case clearError
    }
    
    enum State {
        case idle
        case loading(Int)
        case loadded([ImageCollectionItem])
        case error(Error)
        
        var isLoadding: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }
    
    init() {
        Publishers.system(initial: state,
                          reduce: Self.reduce(state:event:),
                          scheduler: RunLoop.main,
                          feedbacks: [Self.whenLoading(), Self.userInput(input: input.eraseToAnyPublisher())])
            .assign(to: \.state, on: self)
            .store(in: &bag)
    }
    
    func send(event: Event) {
        input.send(event)
    }
    
}

extension CollectionsViewModel {
    
    static func reduce(state: State, event: Event) -> State {
        switch state {
        case .idle:
            switch event {
            case .refreshCollections:
                return .loading(1)
            default:
                return state
            }
        case .loading:
            switch event {
            case .error(let error):
                return .error(error)
            case .loadedCollections(let collections):
                return .loadded(collections.map({ ImageCollectionItem(id: $0.id, title: $0.title,
                                                                      coverImageURL: $0.coverPhoto.urls.thumb,
                                                                      imageSize: CGSize(width: $0.coverPhoto.width,
                                                                                        height: $0.coverPhoto.height)) }))
            default:
                return state
            }
        case .loadded:
            switch event {
            case .loadMoreCollections(let page):
                return .loading(page)
            default:
                return state
            }
        case .error:
            switch event {
            case .clearError:
                return .idle
            default:
                return state
            }
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading(let page) = state else { return Empty().eraseToAnyPublisher() }
            return CollectionsService().fetchCollections(page: page, itemPerPage: 40)
                .map{ Event.loadedCollections($0) }
                .catch { Just(Event.error($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
    
}
