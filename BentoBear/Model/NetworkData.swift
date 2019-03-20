//
//  NetworkData.swift
//  BentoBear
//
//  Created by Yuri Karabatov on 20/03/2019.
//  Copyright © 2019 Yuri Karabatov. All rights reserved.
//

import Foundation
import ReactiveSwift

enum NetworkDataError: Error {
    case badURL
    case networkError
}

protocol NetworkData {
    func fetchData(from url: String) -> SignalProducer<Data, NetworkDataError>
}

/// No custom init here, but we may want to use a custom URLSession eventually.
final class NetworkDataInternet: NetworkData {
    func fetchData(from url: String) -> SignalProducer<Data, NetworkDataError> {
        return SignalProducer.init { observer, _ in
            guard let goodURL = URL(string: url) else {
                observer.send(error: .badURL)
                observer.sendCompleted()
                return
            }

            /// We might also handle the response here to see if we got 200 and not garbage (and no error).
            let completion: (Data?, URLResponse?, Error?) -> Void = { (maybeData, _, error) in
                defer {
                    observer.sendCompleted()
                }

                guard let data = maybeData, error == nil else {
                    observer.send(error: .networkError)
                    return
                }

                observer.send(value: data)
            }

            URLSession.shared.dataTask(with: goodURL, completionHandler: completion).resume()
        }
    }
}
