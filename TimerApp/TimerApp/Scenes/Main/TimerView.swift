//
//  ContentView.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 11.12.24.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel = TimerViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showSuggestedTimers = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "1E1E1E")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    titleView
                    timersListView
                    addTimerView
                }
                if showSuggestedTimers {
                    BlurView(style: .light)
                        .edgesIgnoringSafeArea(.all) 
                }
            }
        }
        .sheet(isPresented: $showSuggestedTimers) {
            SuggestedTimersView(viewModel: viewModel)
                .presentationDetents([.height(395)])
        }
    }
    
    // MARK: - Title View
    private var titleView: some View {
        HStack{
            Text("ტაიმერები")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .padding(.leading, 20)
            Spacer()
            Button(action: {
                showSuggestedTimers = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.trailing, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: 110, alignment: .topLeading)
        .background(Color(hex: "2C2C2C"))
    }
    
    // MARK: - Timer List View
    private var timersListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.timers) { timer in
                    NavigationLink(destination: TimerDetailsView(viewModel: viewModel, timerId: timer.id)) {
                        TimerItemView(viewModel: viewModel, timer: timer)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Adding timer view
    private var addTimerView: some View {
        VStack(spacing: 20) {
            TextField(
                "",
                text: $viewModel.timerTitle,
                prompt: Text("ტაიმერის სახელი...")
                    .foregroundColor(Color(hex: "757575"))
            )
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .foregroundColor(Color(hex: "757575"))
            
            
            HStack(spacing: 10) {
                self.timeInputTextField(text: $viewModel.hours, placeholder: "სთ")
                self.timeInputTextField(text: $viewModel.minutes, placeholder: "წთ")
                self.timeInputTextField(text: $viewModel.seconds, placeholder: "წმ")
            }
            
            
            Button(action: {
                viewModel.addTimer()
            }) {
                Text("დამატება")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 97)
            }
        }
        .padding()
        .background(Color(hex: "2C2C2C"))
        .frame(maxWidth: .infinity, maxHeight: 190)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    TimerView()
}
