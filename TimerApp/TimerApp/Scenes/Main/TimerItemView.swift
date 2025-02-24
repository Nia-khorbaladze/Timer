//
//  TimerItemView.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 13.12.24.
//

import SwiftUI

struct TimerItemView: View {
    @ObservedObject var viewModel: TimerViewModel
    var timer: TimerModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            HStack {
                Text(timer.timerTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    viewModel.deleteTimer(withTitle: timer.timerTitle)
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
            
            Text("\(timer.hours):\(timer.minutes):\(timer.seconds)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            
            HStack(spacing: 16) {
                Button(action: {
                    if timer.isTimerRunning {
                        viewModel.pauseTimer(timer: timer)
                    } else {
                        viewModel.startTimer(timer: timer)
                    }
                }) {
                    Text(timer.isTimerRunning ? "პაუზა" : "დაწყება")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(timer.isTimerRunning ? Color(hex: "FF9500") : Color.green)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    viewModel.restartTimer(timer: timer)
                }) {
                    Text("გადატვირთვა")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color(hex: "2C2C2C"))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

