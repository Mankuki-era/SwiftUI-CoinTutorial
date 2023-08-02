//
//  HomeView.swift
//  SwiftCoinTutorial
//
//  Created by Mankuki_era on 2023/08/01.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                // top movers view
                TopMoversView(viewModel: viewModel)
                
                Divider()
                
                // all coins view
                AllCoinsView(viewModel: viewModel)
            }
            .refreshable {
                viewModel.handleRefresh()
            }
            .onReceive(viewModel.$error, perform: { error in
                if error != nil {
                    showAlert.toggle()
                }
            })
            .alert(isPresented: $showAlert, content: {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "")
                )
            })
            .navigationTitle("Live Prices")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
