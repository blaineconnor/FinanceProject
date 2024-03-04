//
//  CurrencyDaoRepo.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation
import RxSwift

struct CurrencyDaoRepo{
    var cur = BehaviorSubject<[Kurlar]>(value: [Kurlar]())
    let db:FMDatabase?
    
    init(){
        let bundleYolu = Bundle.main.path(forResource: "finance", ofType: ".sqlite")
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniUrl = URL(fileURLWithPath: bundleYolu!)
        db = FMDatabase(path: veritabaniUrl.path)
    }
    
    func get() {
        db?.open()
        
        var list = [Kurlar]()
        do {
            let rs = try db!.executeQuery("SELECT * FROM Kurlar", values: nil)
            while rs.next() {
                let isFavoriteString = rs.string(forColumn: "isFavorite") ?? "false"
                let isFavorite = Bool(isFavoriteString) ?? false
                
                let sira = Int(rs.string(forColumn: "Sira") ?? "") ?? 0
                let forexName = rs.string(forColumn: "forexName") ?? ""
                let kurAdi = rs.string(forColumn: "KurAdi") ?? ""
                let alis = Double(rs.string(forColumn: "Alis") ?? "") ?? 0.0
                let satis = Double(rs.string(forColumn: "Satis") ?? "") ?? 0.0
                
                let dateString = rs.string(forColumn: "UpdateTime") ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let updateTime = dateFormatter.date(from: dateString) ?? Date()
                
                let kur = Kurlar(sira: sira,
                                 forexName: forexName,
                                 kurAdi: kurAdi,
                                 alis: alis,
                                 satis: satis,
                                 updateTime: dateString,
                                 isFavorite: isFavorite)
                list.append(kur)
            }
            cur.onNext(list)
        } catch {
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    
    func update(Sira:Int,Alis:Double, Satis:Double){
        db?.open()
        
        do{
            try db!.executeUpdate("UPDATE Kurlar SET Alis = ?,Satis = ? WHERE Sira = ?", values: [Alis,Satis,Sira])
        }catch{
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    func getFavorites(forUser userId: Int) {
        db?.open()
        
        var list = [Kurlar]()
        do {
            let query = "SELECT * FROM Kurlar WHERE UserId = ?"
            let rs = try db!.executeQuery(query, values: [userId])
            
            while rs.next() {
                let sira = Int(rs.int(forColumn: "Sira"))
                let forexName = rs.string(forColumn: "forexName") ?? ""
                let kurAdi = rs.string(forColumn: "KurAdi") ?? ""
                let alis = rs.double(forColumn: "Alis")
                let satis = rs.double(forColumn: "Satis")
                let updateTimeString = rs.string(forColumn: "UpdateTime") ?? ""
                let isFavorite = rs.bool(forColumn: "isFavorite")
                
                let kur = Kurlar(sira: sira,
                                 forexName: forexName,
                                 kurAdi: kurAdi,
                                 alis: alis,
                                 satis: satis,
                                 updateTime: updateTimeString,
                                 isFavorite: isFavorite)
                list.append(kur)
            }
            cur.onNext(list)
        } catch {
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    
    func toggleFavorite(forSira sira: Int, isFavorite: Bool) {
        db?.open()
        
        do {
            try db!.executeUpdate("UPDATE Kurlar SET isFavorite = ? WHERE Sira = ?", values: [isFavorite, sira])
        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
}
