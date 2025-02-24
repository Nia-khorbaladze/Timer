//
//  TimerModel.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 11.12.24.
//

import Foundation
import Combine

struct TimerModel: Identifiable, Codable {
    let id = UUID()
    let timerTitle: String
    var hours: String
    var minutes: String
    var seconds: String
    var timeRemaining: Int
    let startingTime: Int
    var cancellable: AnyCancellable? = nil
    var isTimerRunning: Bool = false
    var totalRunningTime: TimeInterval = 0
    var startDate: Date? = nil
    
    var history: [TimerSession] = []
    
    enum CodingKeys: String, CodingKey {
        case id, timerTitle, hours, minutes, seconds, timeRemaining, startingTime,
             isTimerRunning, totalRunningTime, startDate, history
    }
}

struct TimerSession: Hashable, Codable {
    let startDate: Date
    let duration: TimeInterval
    
    var durationFormatted: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
