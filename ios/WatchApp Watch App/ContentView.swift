//
//  ContentView.swift
//  WatchApp Watch App
//
//  Created by Seongheon Park on 2022/06/10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        List {
            VStack {
                ForEach(viewModel.meal?.meal ?? ["No meal err"], id: \.self) { meal in
                    Text(meal)
                }
            }
            VStack {
                ForEach(viewModel.timeTable?.items ?? [], id: \.subject) { item in
                    Text(item.subject)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
