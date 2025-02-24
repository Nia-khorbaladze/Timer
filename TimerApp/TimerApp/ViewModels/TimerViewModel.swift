//
//  TimerViewModel.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 11.12.24.
//

import Foundation
import Combine
import AVFoundation

final class TimerViewModel: ObservableObject {
    @Published var timers: [TimerModel] = []
    @Published var timerTitle: String = ""
    @Published var hours: String = ""
    @Published var minutes: String = ""
    @Published var seconds: String = ""
    private var player: AVAudioPlayer!
    private let userDefaultsKey = "timersData"

    init() {
        loadTimers()
    }

    func addTimer() {
        let formattedHours = hours.isEmpty ? "00" : String(format: "%02d", Int(hours) ?? 0)
        let formattedMinutes = minutes.isEmpty ? "00" : String(format: "%02d", Int(minutes) ?? 0)
        let formattedSeconds = seconds.isEmpty ? "00" : String(format: "%02d", Int(seconds) ?? 0)
        
        guard !timerTitle.isEmpty else { return }
        
        let totalSeconds = (Int(formattedHours) ?? 0) * 3600 +
        (Int(formattedMinutes) ?? 0) * 60 +
        (Int(formattedSeconds) ?? 0)
        
        let newTimer = TimerModel(
            timerTitle: timerTitle,
            hours: formattedHours,
            minutes: formattedMinutes,
            seconds: formattedSeconds,
            timeRemaining: totalSeconds, startingTime: totalSeconds
        )
        timers.append(newTimer)
        
        timerTitle = ""
        hours = ""
        minutes = ""
        seconds = ""
    }
    
    func addSuggestedTimer(title: String, hours: Int, minutes: Int, seconds: Int) {
        let formattedHours = String(format: "%02d", hours)
        let formattedMinutes = String(format: "%02d", minutes)
        let formattedSeconds = String(format: "%02d", seconds)
        
        let totalSeconds = (hours * 3600) + (minutes * 60) + seconds
        
        let newTimer = TimerModel(
            timerTitle: title,
            hours: formattedHours,
            minutes: formattedMinutes,
            seconds: formattedSeconds,
            timeRemaining: totalSeconds, startingTime: totalSeconds
        )
        timers.append(newTimer)
    }
    
    func startTimer(timer: TimerModel) {
        guard let index = timers.firstIndex(where: { $0.id == timer.id }) else { return }
        
        let publisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        timers[index].cancellable = publisher
            .sink { [weak self] _ in
                self?.updateTimer(at: index)
            }
        
        timers[index].isTimerRunning = true
        timers[index].startDate = Date()
    }
    
    func pauseTimer(timer: TimerModel) {
        guard let index = timers.firstIndex(where: { $0.id == timer.id }) else { return }
        
        if let startDate = timers[index].startDate {
            let activeTime = Date().timeIntervalSince(startDate)
            timers[index].totalRunningTime += activeTime
            
            let session = TimerSession(startDate: startDate, duration: activeTime)
            timers[index].history.append(session)
            
            timers[index].startDate = nil
        }
        
        timers[index].cancellable?.cancel()
        timers[index].cancellable = nil
        timers[index].isTimerRunning = false
        
        saveTimers()
    }
    
    func restartTimer(timer: TimerModel) {
        guard let index = timers.firstIndex(where: { $0.id == timer.id }) else { return }
        
        timers[index].timeRemaining = timers[index].startingTime
        formatTime(at: index)
    }
    
    func deleteTimer(withTitle title: String) {
         if let index = timers.firstIndex(where: { $0.timerTitle == title }) {
             timers.remove(at: index)
             saveTimers()
         }
     }
    
    func formattedTotalTime(timer: TimerModel) -> String {
        let hours = Int(timer.totalRunningTime) / 3600
        let minutes = (Int(timer.totalRunningTime) % 3600) / 60
        let seconds = Int(timer.totalRunningTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    // MARK: - Private functions
    private func updateTimer(at index: Int) {
        if timers[index].timeRemaining > 0 {
            timers[index].timeRemaining -= 1
            
            formatTime(at: index)
        } else {
            if let startDate = timers[index].startDate {
                let activeTime = timers[index].startingTime - timers[index].timeRemaining
                let session = TimerSession(startDate: startDate, duration: TimeInterval(activeTime))
                timers[index].history.append(session) 
                
                timers[index].startDate = nil
                timers[index].totalRunningTime += TimeInterval(activeTime)
            }
            
            timers[index].cancellable?.cancel()
            timers[index].cancellable = nil
            playSound()
            saveTimers()
        }
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm2", withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func formatTime(at index: Int) {
        let hours = timers[index].timeRemaining / 3600
        let minutes = (timers[index].timeRemaining % 3600) / 60
        let seconds = timers[index].timeRemaining % 60
        
        timers[index].hours = String(format: "%02d", hours)
        timers[index].minutes = String(format: "%02d", minutes)
        timers[index].seconds = String(format: "%02d", seconds)
    }
    
    func saveTimers() {
        do {
            let encodedData = try JSONEncoder().encode(timers)
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        } catch {
            print("Failed to save timers")
        }
    }
    
    func loadTimers() {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                let decodedTimers = try JSONDecoder().decode([TimerModel].self, from: savedData)
                self.timers = decodedTimers
            } catch {
                print("Failed to load timers")
            }
        }
    }
}
