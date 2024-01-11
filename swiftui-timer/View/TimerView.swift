//
//  TimerView.swift
//  swiftui-timer
//
//  Created by Keval Shah on 11/01/24.
//

import SwiftUI

struct TimerView: View {
    
    @EnvironmentObject var timerViewModel: TimerViewModel
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 50) {
                ZStack {
                    Circle()
                        .trim(from: 0, to: timerViewModel.timerProgress)
                        .stroke(.white.opacity(0.03),lineWidth: 80)
                    
                    Circle()
                        .stroke(Color(.mint),lineWidth: 5)
                        .blur(radius: 15)
                        .padding(-2)
                    
                    Circle()
                        .trim(from: 0, to: timerViewModel.timerProgress)
                        .stroke(Color(.mint).opacity(0.7),lineWidth: 15)
                    
                    Text(timerViewModel.timerString)
                        .font(.system(size: 35, weight: .medium))
                        .rotationEffect(.init(degrees: 90))
                        .animation(.none, value: timerViewModel.timerProgress)
                }
                .rotationEffect(.init(degrees: -90))
                .animation(.easeInOut, value: timerViewModel.timerProgress)
                .frame(height: proxy.size.width)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                HStack(spacing: 60) {
                    Button {
                        if timerViewModel.timerState == .counting {
                            timerViewModel.pauseCountdown()
                            timerViewModel.timerState = .paused
                        } else if timerViewModel.timerState == .paused {
                            timerViewModel.startCountdown()
                        } else {
                            timerViewModel.minute = 1
                            timerViewModel.seconds = 0
                            timerViewModel.milliseconds = 0
                            timerViewModel.startCountdown()
                            timerViewModel.timerState = .counting
                        }
                    } label: {
                        Image(systemName: !(timerViewModel.timerState == TimerState.counting) ? "play" : "pause")
                            .font(.largeTitle.bold())
                            .foregroundColor(.black)
                            .frame(width: 70, height: 70)
                            .background {
                                Circle()
                                    .fill(Color(.mint))
                            }
                    }
                    
                    Button {
                        if !(timerViewModel.timerState == .finished) {
                            timerViewModel.stopCountdown()
                            timerViewModel.timerState = .finished
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        }
                    } label: {
                        Image(systemName: "stop")
                            .font(.largeTitle.bold())
                            .foregroundColor(.black)
                            .frame(width: 70, height: 70)
                            .background {
                                Circle()
                                    .fill(Color(.mint))
                            }
                    }
                    .disabled(timerViewModel.timerState == TimerState.finished)
                    .opacity(timerViewModel.timerState == TimerState.finished ? 0.4 : 1)
                }
            }
            .background(.black)
            .preferredColorScheme(.dark)
            .onReceive(timerViewModel.countdownTimer) {
                _ in
                if timerViewModel.timerState == .counting {
                    timerViewModel.updateCountdownStatus()
                }
            }
        }
        }
}

#Preview {
    ContentView()
        .environmentObject(TimerViewModel())
}
