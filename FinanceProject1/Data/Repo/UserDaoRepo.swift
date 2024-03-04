//
//  UserDaoRepo.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation
import RxSwift

class UserDaoRepo {
    var users = BehaviorSubject<[User]>(value: [User]())
    let db: FMDatabase?
    
    init() {
        
        let bundleYolu = Bundle.main.path(forResource: "finance", ofType: ".sqlite")
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniUrl = URL(fileURLWithPath: bundleYolu!)
        db = FMDatabase(path: veritabaniUrl.path)
    }
    
    func insert(Ad: String, Soyad: String, Eposta: String, Telefon: String, KullaniciAdi: String, Sifre: String) {
        db?.open()
        
        do {
            try db!.executeUpdate("INSERT INTO User (Ad, Soyad, Eposta, Telefon, KullaniciAdi, Sifre) VALUES (?, ?, ?, ?, ?, ?)", values: [Ad, Soyad, Eposta, Telefon, KullaniciAdi, Sifre])
        } catch {
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    func update(Id: Int, Telefon: String, Sifre: String) {
        db?.open()
        
        do {
            try db!.executeUpdate("UPDATE User SET Telefon = ?, Sifre = ? WHERE Id = ?", values: [Telefon, Sifre, Id])
        } catch {
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    func login(kullaniciAdi: String, sifre: String) -> Observable<User?> {
            return Observable.create { observer in
                self.db?.open()
                do {
                    let resultSet = try self.db?.executeQuery("SELECT * FROM User WHERE KullaniciAdi = ? AND Sifre = ?", values: [kullaniciAdi, sifre])
                    if let resultSet = resultSet, resultSet.next() {
                        let user = User(Id: Int(resultSet.int(forColumn: "Id")),
                                        Ad: resultSet.string(forColumn: "Ad") ?? "",
                                        Soyad: resultSet.string(forColumn: "Soyad"),
                                        Eposta: resultSet.string(forColumn: "Eposta") ?? "",
                                        Telefon: resultSet.string(forColumn: "Telefon") ?? "",
                                        KullaniciAdi: resultSet.string(forColumn: "KullaniciAdi") ?? "",
                                        Sifre: resultSet.string(forColumn: "Sifre") ?? "",
                                        Bakiye: Double(resultSet.double(forColumn: "Bakiye")))
                        observer.onNext(user)
                    } else {
                        observer.onNext(nil)
                    }
                    observer.onCompleted()
                } catch {
                    print(error.localizedDescription)
                    observer.onError(error)
                }
                self.db?.close()
                return Disposables.create()
            }
        } 
    
    func updatePassword(userId: Int, newPassword: String) {
           db?.open()
           
           do {
               try db!.executeUpdate("UPDATE User SET Sifre = ? WHERE Id = ?", values: [newPassword, userId])
           } catch {
               print(error.localizedDescription)
           }
           
           db?.close()
       }
}
