//
//  MoodDayStorage.swift
//  Echos
//
//  Created by Emma on 21.11.25.
//

import Foundation

struct MoodModel: Codable, Identifiable {
    let id: UUID
    let date: Date
    let mood: Mood
    let text: String?
    
    init(id: UUID = UUID(),
         date: Date = Date(),
         mood: Mood,
         text: String?) {
        self.id = id
        self.date = date
        self.mood = mood
        self.text = text
    }
}

enum MoodDayStorageError: Error {
    case dayLimitReached
}

final class MoodDayStorage {
    
    // MARK: - Singleton
    
    static let shared = MoodDayStorage()
    
    // MARK: - Private properties
    
    private let userDefaults: UserDefaults
    private let storageKey = "mood_day_storage_v1"
    private let maxEntriesPerDay = 5
    
    private var storage: [String: [MoodModel]] = [:]
    
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "ru_RU")
        cal.firstWeekday = 2 // понедельник
        return cal
    }()
    
    private lazy var dayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.calendar = calendar
        df.locale = calendar.locale
        df.timeZone = .current
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    // MARK: - Init
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        loadFromDefaults()
    }
    
    // MARK: - Public API
    
    func moods(for date: Date) -> [MoodModel] {
        let key = dayKey(for: date)
        return storage[key] ?? []
    }
    
    func moodsCount(for date: Date) -> Int {
        return moods(for: date).count
    }
    
    func canAddMood(on date: Date) -> Bool {
        return moodsCount(for: date) < maxEntriesPerDay
    }
    
    @discardableResult
    func addMood(mood: Mood,
                 text: String?,
                 for date: Date = Date()) throws -> MoodModel {
        
        let key = dayKey(for: date)
        var entries = storage[key] ?? []
        
        guard entries.count < maxEntriesPerDay else {
            throw MoodDayStorageError.dayLimitReached
        }
        
        let entry = MoodModel(
            date: date,
            mood: mood,
            text: text
        )
        
        entries.append(entry)
        entries.sort { $0.date < $1.date }
        storage[key] = entries
        
        saveToDefaults()
        return entry
    }
    
    func hasMood(on date: Date) -> Bool {
        return !moods(for: date).isEmpty
    }
    
    func resetAll() {
        storage.removeAll()
        saveToDefaults()
    }
    
    // MARK: - Private helpers
    
    private func dayKey(for date: Date) -> String {
        let startOfDay = calendar.startOfDay(for: date)
        return dayFormatter.string(from: startOfDay)
    }
    
    private func loadFromDefaults() {
        guard let data = userDefaults.data(forKey: storageKey) else {
            storage = [:]
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode([String: [MoodModel]].self, from: data)
            storage = decoded
        } catch {
            storage = [:]
        }
    }
    
    private func saveToDefaults() {
        do {
            let data = try JSONEncoder().encode(storage)
            userDefaults.set(data, forKey: storageKey)
        } catch {
        }
    }
}

