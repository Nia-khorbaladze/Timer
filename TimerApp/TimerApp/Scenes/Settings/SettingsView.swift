//
//  SettingsView.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 25.02.25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack() {
            Text(viewModel.selectedLanguage == .english ? "Language" : "ენა")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
            
            Divider()

            HStack {
                Text("English")
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding()
                    .padding(.trailing, 15)

                Spacer()

                Toggle("", isOn: Binding(
                    get: { viewModel.selectedLanguage == .georgian },
                    set: { newValue in
                        viewModel.updateLanguage(newValue ? .georgian : .english)
                    }
                ))
                .labelsHidden()
                .frame(width: 50)
                .toggleStyle(SwitchToggleStyle(tint: .blue))

                Spacer()

                Text("ქართული")
                    .foregroundColor(.white)
                    .font(.title3)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .background(Color(hex: "1E1E1E").edgesIgnoringSafeArea(.all))
    }
}
