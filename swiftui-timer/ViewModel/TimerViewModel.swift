//
//  TimerViewModel.swift
//  swiftui-timer
//
//  Created by Keval Shah on 11/01/24.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

enum TimerState {
    case counting
    case paused
    case finished
}

enum TimeValueType {
    case stringValue
    case calculatedValue
}

class TimerViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // MARK: Timer Variables
    let countdownTimer = Timer.TimerPublisher(interval: 0.01, runLoop: .main, mode: .default).autoconnect()
    @Published var timerProgress: CGFloat = 1
    
    @Published var minute: Int = 0
    @Published var seconds: Int = 0
    @Published var milliseconds: Int = 0
    
    @Published var timerString: String = "00:00:000"
    
    @Published var timerState: TimerState = .finished
    
    @Published var elapsedMilliseconds: Int = 0
    @Published var totalMilliseconds: Int = 0
    
    override init() {
        super.init()
        self.authorizePushNotifications()
    }
    
    // MARK: Timer Methods
    
    func startCountdown() {
        timerState = .counting
        timerString = "\(minute):\(seconds):\(milliseconds)"
        elapsedMilliseconds = getTimerCalculatedValue(minutes: minute, seconds: seconds, milliseconds: milliseconds)
        if timerState == .counting {
            totalMilliseconds = elapsedMilliseconds
        } else if timerState == .paused {
            timerState = .counting
        }
    }
    
    func pauseCountdown() {
        timerState = .paused
        minute = elapsedMilliseconds / 60000
        seconds = (elapsedMilliseconds / 1000) % 60
        milliseconds = elapsedMilliseconds % 1000
    }
    
    func stopCountdown() {
        withAnimation {
            timerState = .finished
            minute = 0
            seconds = 0
            milliseconds = 0
            timerProgress = 1
        }
        elapsedMilliseconds = 0
        totalMilliseconds = 0
        timerString = "00:00:000"
    }
    
    func updateCountdownStatus() {
        elapsedMilliseconds -= 10
        timerProgress = CGFloat(elapsedMilliseconds) / CGFloat(totalMilliseconds)
        timerProgress = (timerProgress < 0 ? 0 : timerProgress)
        minute = elapsedMilliseconds / 60000
        seconds = (elapsedMilliseconds / 1000) % 60
        milliseconds = elapsedMilliseconds % 1000
        timerString = getTimerStringValue(minutes: minute, seconds: seconds, milliseconds: milliseconds)
        if minute <= 0 && seconds <= 0 && milliseconds <= 0 {
            pushNotification()
            timerState = .finished
            timerString = "00:00:000"
        }
    }
    
    //MARK: Background Notification
    
    func authorizePushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in
        }
        UNUserNotificationCenter.current().delegate = self
    }
    
    func pushNotification() {
        let notificationDetail = UNMutableNotificationContent()
        notificationDetail.title = "Countdown Timer"
        notificationDetail.subtitle = "The timer has completed counting down."
        notificationDetail.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationDetail, trigger: .none)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    // MARK: Timer Calculations
    func getTimerCalculatedValue(minutes: Int, seconds: Int, milliseconds: Int) -> Int {
        return (minute * 60000) + (seconds * 1000) + milliseconds
    }
    
    func getTimerStringValue(minutes: Int, seconds: Int, milliseconds: Int) -> String {
        return "\(minute >= 10 ? "\(minute)":"0\(minute)"):\(seconds >= 10 ? "\(seconds)":"0\(seconds)"):\(milliseconds)"
    }
}
