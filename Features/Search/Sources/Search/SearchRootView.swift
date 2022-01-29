//
//  SearchRootView.swift
//
//
//  Created by Karthikkeyan Bala Sundaram on 2022-01-28.
//

import Combine
import FeatureAbstract
import SwiftUI

public struct SearchRootView: View {
    private let networking: Networking
    private let viewModel: SearchViewModel

    public init(networking: Networking) {
        let viewModel = SearchViewModel(networking: networking)

        self.networking = networking
        self.viewModel = viewModel
    }

    public var body: some View {
        SearchView()
            .environmentObject(viewModel)
    }
}

// MARK: - Previews

struct SearchRootView_Previews: PreviewProvider {
    struct MockNetwork: Networking {
        func send(request _: URLRequest) -> AnyPublisher<Data?, ServiceError> {
            Empty<Data?, ServiceError>().eraseToAnyPublisher()
        }
    }

    static var previews: some View {
        SearchRootView(networking: MockNetwork())
    }
}
