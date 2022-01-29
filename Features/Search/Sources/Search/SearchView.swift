//
//  SwiftUIView.swift
//
//
//  Created by Karthikkeyan Bala Sundaram on 2022-01-28.
//

import Style
import SwiftUI
import UIComponent

struct SearchView: View {
    @EnvironmentObject private var viewModel: SearchViewModel

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ZStack {
                    List {
                        ForEach(viewModel.searchResult) { business in
                            SearchResultCell(business: business, proxy: proxy)
                        }.buttonStyle(BorderlessButtonStyle())
                            .padding(.vertical, .doubleUnit)

                        if viewModel.canLoadMore {
                            HStack {
                                Spacer()

                                Spinner(isAnimating: viewModel.canLoadMore)
                                    .frame(width: .septuple, height: .septuple, alignment: .center)
                                    .onAppear { viewModel.loadMore() }

                                Spacer()
                            }.padding(.quadrupleUnit)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                        }
                    }.listStyle(PlainListStyle())

                    if viewModel.showSpinner {
                        FullScreenSpinnerView(isAnimating: viewModel.showSpinner)
                    }
                }.frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            }.navigationTitle(Text(String.navigationTitle))
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $viewModel.userInput, placement: .navigationBarDrawer(displayMode: .always), prompt: Text(String.searchPlaceholder))
                .onSubmit(of: .search) {
                    viewModel.searchBusiness()
                }.alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text(String.navigationTitle), message: Text(String.errorMessage), dismissButton: .cancel())
                }
        }
    }
}

// MARK: - Cell

struct SearchResultCell: View {
    @Environment(\.colorScheme) private var colorScheme

    let business: Business
    let proxy: GeometryProxy

    var body: some View {
        VStack(spacing: .doubleUnit) {
            AsyncImage(url: business.imageURL)
                .frame(width: proxy.size.width - .quadrupleUnit, height: CGFloat(.imageHeight), alignment: .center)
                .clipped()

            HStack(alignment: .top) {
                Text(business.name)
                    .font(.headline) +

                    Text("\n\(business.location.city), \(business.location.state)")
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()

                RatingView(rating: business.rating)
            }.lineSpacing(.halfUnit)
                .padding(EdgeInsets(horizontal: .doubleUnit))

            HStack(spacing: .singleUnit) {
                Button {
                    if let url = URL(string: "tel://" + business.phoneNumber), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } label: {
                    Text(business.phoneNumber)
                }.font(.body)
                    .foregroundColor(.blue)

                Spacer()
            }.padding(EdgeInsets(top: .zero, bottom: business.transactions.isEmpty ? .doubleUnit : .zero, horizontal: .doubleUnit))

            if !business.transactions.isEmpty {
                HStack(spacing: .singleUnit) {
                    ForEach(business.transactions, id: \.self) { transaction in
                        Text(transaction.capitalized)
                            .font(.callout.bold())
                            .foregroundColor(.white)
                            .padding(EdgeInsets(horizontal: .singleUnit, vertical: .halfUnit))
                            .background(Color.blue)
                            .cornerRadius(.halfUnit)
                    }

                    Spacer()
                }.padding(EdgeInsets(bottom: .doubleUnit, horizontal: .doubleUnit))
            }
        }.background(colorScheme == .dark ? Color.black.opacity(0.75) : Color.white)
            .cornerRadius(.singleUnit)
            .shadow(color: .secondary.opacity(0.25), radius: .halfUnit, x: .zero, y: .zero)
            .padding(EdgeInsets(top: .zero, leading: .doubleUnit, bottom: .singleUnit, trailing: .doubleUnit))
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
    }
}

// MARK: - Copy

private extension String {
    static let navigationTitle = NSLocalizedString("com.perfectsearch.search.navigationtitle", bundle: .module, comment: "")
    static let searchPlaceholder = NSLocalizedString("com.perfectsearch.search.placeholder", bundle: .module, comment: "")

    static let errorMessage = NSLocalizedString("com.perfectsearch.search.error", bundle: .module, comment: "")
}

// MARK: - Constants

private extension CGFloat {
    static let imageHeight: CGFloat = 200
    static let placeholderHeight: CGFloat = 300
}
