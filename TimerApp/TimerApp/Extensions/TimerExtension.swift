//
//  TimerExtension.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 16.12.24.
//

import Foundation

extension TimerModel {
    func averageDuration(language: AppLanguage) -> String {
        guard !history.isEmpty else { return language == .english ? "00:00" : "00:00" }

        let totalDurationInSeconds = history.reduce(0) { $0 + $1.duration }
        let averageDurationInSeconds = totalDurationInSeconds / Double(history.count)

        let hours = Int(averageDurationInSeconds) / 3600
        let remainingSeconds = Int(averageDurationInSeconds) % 3600
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60

        if hours > 0 {
            return language == .english
                ? String(format: "%d hr %d min %d sec", hours, minutes, seconds)
                : String(format: "%d სთ %d წთ %d წმ", hours, minutes, seconds)
        } else if minutes > 0 {
            return language == .english
                ? String(format: "%d min %d sec", minutes, seconds)
                : String(format: "%d წთ %d წმ", minutes, seconds)
        } else {
            return language == .english
                ? String(format: "%d sec", seconds)
                : String(format: "%d წმ", seconds)
        }
    }

    func totalDuration(language: AppLanguage) -> String {
        let totalDurationInSeconds = history.reduce(0) { $0 + $1.duration }

        if totalDurationInSeconds < 0 {
            return language == .english ? "No duration" : "მონაცემები არ არის"
        }
        
        let roundedTotalDurationInSeconds = round(totalDurationInSeconds)
        if roundedTotalDurationInSeconds < 60 {
            return language == .english
                ? String(format: "%d sec", Int(roundedTotalDurationInSeconds))
                : String(format: "%d წმ", Int(roundedTotalDurationInSeconds))
        }
        
        if roundedTotalDurationInSeconds < 3600 {
            let minutes = Int(roundedTotalDurationInSeconds) / 60
            let seconds = Int(roundedTotalDurationInSeconds) % 60
            return language == .english
                ? String(format: "%d min %d sec", minutes, seconds)
                : String(format: "%d წთ %d წმ", minutes, seconds)
        }
        
        let hours = Int(roundedTotalDurationInSeconds) / 3600
        let remainingSeconds = Int(roundedTotalDurationInSeconds) % 3600
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        
        return language == .english
            ? String(format: "%d hr %d min %d sec", hours, minutes, seconds)
            : String(format: "%d სთ %d წთ %d წმ", hours, minutes, seconds)
    }

    func sessionsCount(language: AppLanguage) -> String {
        return language == .english
            ? "\(history.count) sessions"
            : "\(history.count) სესია"
    }
}
