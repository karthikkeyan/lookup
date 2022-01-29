//
//  RootView.swift
//  PerfectSearch
//
//  Created by Karthikkeyan Bala Sundaram on 2022-01-28.
//

import Search
import SwiftUI

struct RootView: View {
    private let bootstrap = Bootstrap()

    var body: some View {
        SearchRootView(networking: bootstrap.networkClient)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
