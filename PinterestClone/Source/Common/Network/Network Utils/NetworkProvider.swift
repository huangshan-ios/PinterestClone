//
//  NetworkProvider.swift
//  PinterestClone
//
//  Created by SonHoang on 12/2/20.
//

import Foundation
import Combine

typealias NetworkResponse = (data: Data, response: URLResponse)

class NetworkProvider<T: Router> {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func requestAPI(_ router: T) -> AnyPublisher<NetworkResponse, Error> {
        
        let requestSession = session
        
        return Deferred {
            
            Future { promise in
                
                var cancellable: AnyCancellable? = nil
                var queryItems: [URLQueryItem] = []
                var jsonData: Data? = nil
                
                if let parameters = router.parameters {
                    switch router.parameterType {
                    case .none: break
                    case .params:
                        queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
                    case .body:
                        jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    }
                }
                
                var urlParameters = URLComponents()
                urlParameters.scheme = "https"
                urlParameters.host = router.baseURL.absoluteString
                urlParameters.path = router.path
                urlParameters.queryItems = queryItems
                
                if let url = urlParameters.url {
                    var request = URLRequest(url: url)
                    
                    if let headers = router.headers {
                        for (key, value) in headers {
                            request.addValue(value, forHTTPHeaderField: key)
                        }
                    }

                    request.httpMethod = router.method.rawValue
                    request.httpBody = jsonData
                    
                    cancellable = requestSession.dataTaskPublisher(for: request)
                        .sink { completion in
                            if case let .failure(error) = completion  {
                                promise(.failure(error))
                            }
                            cancellable?.cancel()
                            cancellable = nil
                        } receiveValue: { response in
                            promise(.success(response))
                            cancellable?.cancel()
                            cancellable = nil
                        }
                    
                } else {
                    promise(.failure(NetworkError.badURL.error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
