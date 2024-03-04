//
//  AlSatDaoRepo.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 23.02.2024.
//

import Foundation
import RxSwift

struct AlSatDaoRepo {
    var cur = BehaviorSubject<[Exchange]>(value: [Exchange]())
    let db: FMDatabase?

    init() {
        let bundleYolu = Bundle.main.path(forResource: "finance", ofType: ".sqlite")
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniUrl = URL(fileURLWithPath: bundleYolu!)
        db = FMDatabase(path: veritabaniUrl.path)
    }
    
    func buyExchange(kur: String, miktar: Double, alisFiyati: Double, userId: Int) -> Bool {
        guard var currentUser = SessionManager.shared.getCurrentUser(), var bakiye = currentUser.Bakiye else {
            return false
        }
        let toplamMaliyet = miktar * alisFiyati
        guard bakiye >= toplamMaliyet else {
            return false
        }
        
        if let existingExchange = getExchangeByUserAndCurrency(userId: userId, kur: kur) {
            let newAmount = existingExchange.Deger! + miktar
            updateExchangeAmount(id: existingExchange.Id!, newValue: newAmount, miktar: existingExchange.Miktar!)
        } else {
            insertExchange(kur: kur, deger: miktar, userId: userId, alisFiyati: alisFiyati, miktar: miktar)
        }

        bakiye -= toplamMaliyet
        updateUserBalance(userId: userId, newBalance: bakiye)
        
        if var updatedCurrentUser = SessionManager.shared.getCurrentUser() {
            updatedCurrentUser.Bakiye = bakiye
            SessionManager.shared.updateCurrentUser(with: updatedCurrentUser)
        }
        
        return true
    }

    func sellExchange(kur: String, miktar: Double, satisFiyati: Double, userId: Int) -> Bool {
        guard let existingExchange = getExchangeByUserAndCurrency(userId: userId, kur: kur), var existingAmount = existingExchange.Deger, var existingQuentity = existingExchange.Miktar else {
            return false
        }
        guard existingAmount >= miktar else {
            return false
        }
        
        existingAmount -= miktar
        if existingAmount == 0 {
            deleteExchange(id: existingExchange.Id!)
        } else {
            updateExchangeAmount(id: existingExchange.Id!, newValue: existingAmount, miktar: existingQuentity)
        }
        
        guard var currentUser = SessionManager.shared.getCurrentUser(), var bakiye = currentUser.Bakiye else {
            return false
        }
        let gelir = miktar * satisFiyati
        bakiye += gelir
        updateUserBalance(userId: userId, newBalance: bakiye)
        
        if var updatedCurrentUser = SessionManager.shared.getCurrentUser() {
            updatedCurrentUser.Bakiye = bakiye
            SessionManager.shared.updateCurrentUser(with: updatedCurrentUser)
        }
        
        return true
    }

    
    private func getExchangeByUserAndCurrency(userId: Int, kur: String) -> Exchange? {
        
        db?.open()
      
        
        guard let result = db?.executeQuery("SELECT * FROM Exchange WHERE UserId = ? AND Kur = ?", withArgumentsIn: [userId, kur]), result.next() else {
            return nil
        }
        
        return Exchange(Id: Int(result.int(forColumn: "Id")), Kur: result.string(forColumn: "Kur"), Deger: result.double(forColumn: "Deger"), UserId: Int(result.int(forColumn: "UserId")), AlisFiyati: result.double(forColumn: "AlisFiyati"), Miktar: result.double(forColumn: "Miktar"))
    }
    
    private func insertExchange(kur: String, deger: Double, userId: Int, alisFiyati: Double, miktar: Double) {
        db?.open()
        
        do{
            try db!.executeUpdate("INSERT INTO Exchange (Kur, Deger, UserId, AlisFiyati, Miktar) VALUES (?, ?, ?, ?)", values: [kur, deger, userId, alisFiyati, miktar])
        } catch {
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    private func updateExchangeAmount(id: Int, newValue: Double, miktar: Double) {
        db?.open()
        
        do{
            try db!.executeUpdate("UPDATE Exchange SET Deger = ?, Miktar = ? WHERE Id = ?", values: [newValue, miktar, id])
        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    private func deleteExchange(id: Int) {
        db?.open()
        
        db!.executeUpdate("DELETE FROM Exchange WHERE Id = ?", withArgumentsIn: [id])
    }
    
    private func updateUserBalance(userId: Int, newBalance: Double) {
        db?.open()
        do{
            try db!.executeUpdate("UPDATE User SET Bakiye = ? WHERE Id = ?", values: [newBalance, userId])
        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
   
}
