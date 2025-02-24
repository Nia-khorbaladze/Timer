//
//  SuggestedTimersView.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 16.12.24.
//

import SwiftUI

struct SuggestedTimersView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.dismiss) private var dismiss
    
    let suggestedTimers = [
        ("03:00", "ჩაის დაყენება"),
        ("07:00", "HIIT ვარჯიში"),
        ("10:00", "კვერცხის მოხარშვა"),
        ("15:00", "შესვენება"),
        ("20:00", "ყავის პაუზა"),
        ("25:00", "პომოდორო"),
        ("30:00", "მედიტაცია"),
        ("45:00", "ვარჯიში"),
        ("60:00", "სამუშაო სესია"),
        ("50:00", "მეცადინეობა"),
        ("40:00", "წიგნის წაკითხვა"),
        ("30:00", "ვიდეო თამაშები"),
        ("1:20:00", "იოგა"),
        ("12:00", "ორცხობილის გამოცხობა"),
        ("20:00", "ხატვა")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("სწრაფი ტაიმერები")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.leading, 20)
                .foregroundColor(.white)
            
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 12
                ) {
                    ForEach(Array(suggestedTimers.enumerated()), id: \.offset) { index, timer in
                        let (time, title) = timer
                        Button(action: {
                            addSuggestedTimer(time: time, title: title)
                            dismiss()
                        }) {
                            VStack {
                                Text(time)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                Text(title)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, minHeight: 94)
                            .background(Color(hex: "2C2C2C"))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color(hex: "1E1E1E").edgesIgnoringSafeArea(.all))
    }
    
    private func addSuggestedTimer(time: String, title: String) {
        let components = time.split(separator: ":").compactMap { Int($0) }
        
        let hours = components.count == 3 ? components[0] : 0
        let minutes = components.count >= 2 ? components[components.count - 2] : 0
        let seconds = components.count >= 1 ? components.last ?? 0 : 0
        
        viewModel.addSuggestedTimer(title: title, hours: hours, minutes: minutes, seconds: seconds)
    }
}
