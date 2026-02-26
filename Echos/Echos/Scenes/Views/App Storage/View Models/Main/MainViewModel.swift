//
//  MainViewModel.swift
//  Echos
//
//  Created by Emma on 17.11.25.
//

import Foundation

final class MainViewModel {
    
    init() {
       
    }
    
    let provider = AppStateStorage.shared.userSession
    
    func returnUserName() -> String {
        print("Email:", provider?.userID ?? "нет email")
        print("Имя:", provider?.name ?? "нет имени")
        print("Email:", provider?.email ?? "нет email")
        return "\(provider?.middleName ?? "") \(provider?.name ?? "") !"
    }
    
    func saveCommentAndEmotional(text: String, mood: Mood) {
        do {
            try MoodDayStorage.shared.addMood(
                mood: mood,
                text: text,
                for: Date()
            )
        } catch MoodDayStorageError.dayLimitReached {
            print("Vsyo Polniya")
        } catch {
            print("Neizvestnaya oshibka: \(error)")
        }
    }
}

