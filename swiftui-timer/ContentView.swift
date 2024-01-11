//
//  ContentView.swift
//  swiftui-timer
//
//  Created by Keval Shah on 11/01/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var timerViewModel: TimerViewModel
    
    var body: some View {
        VStack {
            TimerView()
                .environmentObject(timerViewModel)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
