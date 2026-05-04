//
//  Date+Extensions.swift
//  Echos
//
//  Created by Michael Grigoryan on 19.03.26.
//

import Foundation

private let calendar = Calendar.current

struct EchosDate: Codable {
    private let date: Date
    
    init(date: Date) {
        self.date = calendar.startOfDay(for: date)
    }
}

extension EchosDate: Equatable {
    static func == (lhs: EchosDate, rhs: EchosDate) -> Bool {
        return lhs.date == rhs.date
    }
}
