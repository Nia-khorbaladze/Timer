//
//  DateExtension.swift
//  TimerApp
//
//  Created by Nkhorbaladze on 13.12.24.
//

import Foundation

extension Date {
    func georgianDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ka_GE")
        return formatter.string(from: self)
    }

    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
