//
//  SpinnerView.swift
//
//
//  Created by Karthikkeyan Bala Sundaram on 2022-01-28.
//

import Style
import SwiftUI
import UIComponent

struct FullScreenSpinnerView: View {
    let isAnimating: Bool

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Spinner(isAnimating: isAnimating)
                        .frame(width: .sextupleUnit, height: .sextupleUnit, alignment: .center)

                    Spacer()
                }.padding(.quadrupleUnit)

                Spacer()
            }.frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
    }
}

struct FullScreenSpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenSpinnerView(isAnimating: true)
    }
}
