//
//  InputFieldExtension.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 11.12.24.
//

import SwiftUI

extension View {
    func timeInputTextField(text: Binding<String>, placeholder: String) -> some View {
        TextField(
            "",
            text: text,
            prompt: Text(placeholder)
                .foregroundColor(Color(hex: "757575"))
        )
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .foregroundColor(Color(hex: "757575"))
    }
}
