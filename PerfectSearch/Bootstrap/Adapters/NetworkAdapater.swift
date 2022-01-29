//
//  NetworkAdapater.swift
//  PerfectSearch
//
//  Created by Karthikkeyan Bala Sundaram on 2022-01-28.
//

import Combine
import FeatureAbstract
import Foundation
import Network

final class NetworkAdapater: Networking {
    private lazy var networkComponents: NetworkComponents = {
        let builder = NetworkServiceBuilder(platform: URLSession.shared, infoProviders: [])
        return builder.build()
    }()

    func send(request: URLRequest) -> AnyPublisher<Data?, ServiceError> {
        networkComponents
            .service
            .send(request: request)
            .map { $0.payload }
            .mapError { ServiceError(underlyingError: $0, code: $0.statusCode) }
            .eraseToAnyPublisher()
    }
}
