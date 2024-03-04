//
//  SessionManager.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 15.02.2024.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    private var currentUser: User? 
    private var userPortfolio: [Exchange]?
    
    private init() {}
    
    func setCurrentUser(user: User?) {
        currentUser = user
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func updateCurrentUser(with user: User) {
           currentUser = user
       }    
   
    func clearCurrentUser() {
        currentUser = nil
    }
}

