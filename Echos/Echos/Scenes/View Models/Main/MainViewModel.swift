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
        if let name = provider?.name {
            return name + "!"
        }
        return ""
    }
}

