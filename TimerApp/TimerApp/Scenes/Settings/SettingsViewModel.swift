//
//  SettingsViewModel.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 25.02.25.
//

import SwiftUI

enum AppLanguage: String {
    case georgian = "ქართული"
    case english = "English"
}
final class SettingsViewModel: ObservableObject {
    @AppStorage("selectedLanguage") var selectedLanguageRawValue: String = AppLanguage.english.rawValue
    
    var selectedLanguage: AppLanguage {
        get { AppLanguage(rawValue: selectedLanguageRawValue) ?? .english }
        set { selectedLanguageRawValue = newValue.rawValue }
    }
    
    func updateLanguage(_ language: AppLanguage) {
        selectedLanguage = language
    }
}
