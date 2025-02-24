//
//  TimerDetailsView.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 13.12.24.
//

import SwiftUI

struct TimerDetailsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let timerId: UUID
    
    private var timer: TimerModel? {
        viewModel.timers.first { $0.id == timerId }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "1E1E1E")
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                navigationBar
                totalTime
                timerOverview
                history
            }
        }
    }
    
    // MARK: - Navigation bar
    private var navigationBar: some View {
        ZStack {
            Color(hex: "2C2C2C")
                .edgesIgnoringSafeArea(.top)
            
            HStack {
                backButton
                Spacer()
                Text(timer?.timerTitle ?? "No timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        .frame(height: 110)
        .navigationBarHidden(true) 
    }

    
    // MARK: - Total time
    private var totalTime: some View {
        VStack(spacing: 10) {
            Image("timer")
            Text("ხანგრძლივობა")
                .font(.headline)
                .foregroundColor(.white)
            
            if let timer = timer {
                Text(viewModel.formattedTotalTime(timer: timer))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            } else {
                Text("No Timer")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 180)
        .frame(maxWidth: 360)
        .background(Color(hex: "2C2C2C"))
        .cornerRadius(12)
    }
    
    // MARK: - Overview
    private var timerOverview: some View {
        VStack {
            if let timer = timer {
                timerRow(title: "დღევანდელი სესიები", value: timer.sessionsCount())
            }
            Divider()
                .background(Color(hex: "757575"))
                .frame(width: 320)
            if let timer = timer {
                timerRow(title: "საშუალო ხანგრძლივობა", value: timer.averageDuration())
            }
            Divider()
                .background(Color(hex: "757575"))
                .frame(width: 320)
            if let timer = timer {
                timerRow(title: "ჯამური დრო", value: timer.totalDuration())
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 150)
        .frame(maxWidth: 360)
        .background(Color(hex: "2C2C2C"))
        .cornerRadius(12)
    }
    
    // MARK: - History
    private var history: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("აქტივობის ისტორია")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 28)
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
            
            if let timer = timer {
                List {
                    ForEach(groupedHistory(for: timer), id: \.key) { date, sessions in
                        Section(header: Text(date)
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "999999"))
                        ) {
                            ForEach(sessions, id: \.self) { session in
                                historyRow(session: session)
                            }
                        }
                        .listSectionSeparator(.hidden)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(hex: "1E1E1E"))
                .listStyle(PlainListStyle())
            }
        }
        .background(Color(hex: "1E1E1E"))
    }
    
    // MARK: - Back button
    private var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
            }
        }
    }
    
    // MARK: - Timer overview row
    private func timerRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(Color(hex: "999999"))
                .padding(.leading, 5)
                .bold()
            Spacer()
            Text(value)
                .bold()
                .foregroundColor(.white)
                .padding(.trailing, 5)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Timer history view
    private func historyRow(session: TimerSession) -> some View {
        HStack {
            Text(session.startDate.formattedTime())
                .font(.body)
                .foregroundColor(.white)
            Spacer()
            Text(session.durationFormatted)
                .font(.body)
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .listRowBackground(Color(hex: "1E1E1E"))
    }
    
    // MARK: - Helpers
    private func groupedHistory(for timer: TimerModel) -> [(key: String, value: [TimerSession])] {
        let grouped = Dictionary(grouping: timer.history) { session in
            session.startDate.georgianDate()
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
}

#Preview {
    TimerView()
}
