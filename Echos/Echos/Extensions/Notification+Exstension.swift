//
//  Notification+Exstension.swift
//  Echos
//
//  Created by Emma on 23.11.25.
//

import Foundation

extension Notification.Name {
    static let moodDidSave = Notification.Name("mood.didSave")
}

enum MoodNotificationKeys {
    static let mood = "mood"
    static let text = "text"
}
