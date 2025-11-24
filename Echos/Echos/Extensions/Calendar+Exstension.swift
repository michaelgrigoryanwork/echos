//
//  Calendar.swift
//  Echos
//
//  Created by Emma on 20.11.25.
//

import Foundation


extension Calendar {
    func numberOfDays(in monthDate: Date) -> Int {
        range(of: .day, in: .month, for: monthDate)?.count ?? 30
    }
    
    func weekRange(for date: Date) -> [Date] {
        let startOfWeek = self.date(from: self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
        
        return (0..<7).compactMap {
            self.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
}

enum DateHelper {
    
    private static var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "ru_RU")
        return cal
    }()
    
    private static var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static func onlyDate(from date: Date) -> Date {
        calendar.startOfDay(for: date)
    }
    
    static func date(day: Int, month: Int, year: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components).map { onlyDate(from: $0) }
    }
    
    static func string(from date: Date) -> String {
        let only = onlyDate(from: date)
        return dayFormatter.string(from: only)
    }
    
    static func date(from string: String) -> Date? {
        guard let date = dayFormatter.date(from: string) else { return nil }
        return onlyDate(from: date)
    }
}
