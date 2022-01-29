//
//  SearchViewModel.swift
//
//
//  Created by Karthikkeyan Bala Sundaram on 2022-01-28.
//

import Combine
import FeatureAbstract
import Foundation

struct Location: Codable {
    let city: String
    let state: String
}

struct Business: Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, rating, location, transactions
        case phoneNumber = "display_phone"
        case imageURL = "image_url"
    }

    let id: String
    let name: String
    let phoneNumber: String
    let rating: Float
    let imageURL: URL
    let location: Location
    let transactions: [String]
}

final class SearchViewModel: ObservableObject {
    private let networking: Networking

    @Published var showAlert: Bool = false
    @Published var userInput: String = ""
    @Published private(set) var searchResult: [Business] = []
    @Published private(set) var canLoadMore = false
    @Published private(set) var showSpinner = false

    // San Fransisco
    @Published var latitude: Double = 37.786882
    @Published var longitude: Double = -122.399972

    private var cancellableBag: Set<AnyCancellable> = []
    private var offset: Int = 0

    init(networking: Networking) {
        self.networking = networking

        $userInput
            .sink { [weak self] value in
                guard value.isEmpty else { return }

                self?.canLoadMore = false
                self?.searchResult = []
            }.store(in: &cancellableBag)
    }

    func searchBusiness(isLoadMore: Bool = false) {
        showAlert = false

        guard !userInput.isEmpty else {
            searchResult = []
            return
        }

        let urlString = "https://api.yelp.com/v3/businesses/search"
        var components = URLComponents(string: urlString)
        components?.queryItems = [
            URLQueryItem(name: "term", value: userInput),
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "offset", value: "\(offset)"),
        ]

        guard let url = components?.url else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue(.yelpBearerAuth, forHTTPHeaderField: .authorizationKey)
        request.httpMethod = "GET"

        showSpinner = !isLoadMore
        networking
            .send(request: request)
            .map { $0 ?? .emptyJSONData }
            .decode(type: SearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.showAlert = true
                }
                self?.showSpinner = false
            } receiveValue: { [weak self] value in
                self?.showSpinner = false
                self?.searchResult = value.businesses
                self?.offset += 1
                self?.canLoadMore = !value.businesses.isEmpty
            }.store(in: &cancellableBag)
    }

    func loadMore() {
        guard canLoadMore else {
            return
        }

        searchBusiness(isLoadMore: true)
    }
}

// MARK: - Constants

private extension String {
    static let authorizationKey = "Authorization"
    static let yelpBearerAuth = "Bearer O5H9A0D9qSnN2Q-MQerhCuUljXnNlRaYGZdxv0HM5SLfznvtTDj_lwhMg-_RF7Tq-pwB7-KeNvoFRDoEL0Or7xndhButRGOohZn2l8nanLQAIIe2MISSmvw525SmYXYx"
}

private struct SearchResponse: Codable {
    var businesses: [Business]
}

private extension Data {
    static let emptyJSONData = """
    {
        "businesses": []
    }
    """.data(using: .utf8)!
}
