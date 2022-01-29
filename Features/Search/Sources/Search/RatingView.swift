//
//  RatingView.swift
//
//
//  Created by Karthikkeyan Bala Sundaram on 2022-01-28.
//

import SwiftUI

struct RatingView: View {
    let rating: Float
    var body: some View {
        HStack(spacing: .halfUnit) {
            Image(systemName: "star.fill")

            Text(String(format: "%0.1f", rating))
        }.foregroundColor(.white)
            .font(Font.footnote.bold())
            .padding(EdgeInsets(horizontal: .singleUnit, vertical: .halfUnit))
            .background(Color.green)
            .cornerRadius(.halfUnit)
    }
}
