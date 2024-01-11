//
//  swiftui_timerApp.swift
//  swiftui-timer
//
//  Created by Keval Shah on 11/01/24.
//

import SwiftUI

@main
struct swiftui_timerApp: App {
    
    @StateObject var timerViewModel: TimerViewModel = .init()
    
    // MARK: Backgorund functionality
    
    @Environment(\.scenePhase) var appPhase
    @State var lastActiveTime: Date = Date()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerViewModel)
        }
        .onChange(of: appPhase, { oldValue, newValue in
            if timerViewModel.timerState == .counting {
                if newValue == .background {
                    lastActiveTime = Date()
                }
                
                if newValue == .active {
                    let timeDifference = (Date().timeIntervalSince(lastActiveTime)*1000).rounded()
                    print(timeDifference)
                    if timerViewModel.elapsedMilliseconds - Int(timeDifference) <= 0 {
                        timerViewModel.timerState = .finished
                        timerViewModel.elapsedMilliseconds = 0
                    } else {
                        timerViewModel.elapsedMilliseconds -= Int(timeDifference)
                        timerViewModel.timerState = .counting
                    }
                }
            }
        })
    }
}
