//
//  PortfolioDaoRepo.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 29.02.2024.
//

import Foundation
import RxSwift

struct PortfolioDaoRepo {
    var cur = BehaviorSubject<[Exchange]>(value: [])
    let db: FMDatabase?

    init() {
        let bundleYolu = Bundle.main.path(forResource: "finance", ofType: ".sqlite")
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniUrl = URL(fileURLWithPath: bundleYolu!)
        db = FMDatabase(path: veritabaniUrl.path)
    }

    func getPortfolioForCurrentUser() -> Observable<[Exchange]> {
        guard let currentUser = SessionManager.shared.getCurrentUser() else {
            return Observable.error(NSError(domain: "PortfolioDaoRepo", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı."]))
        }

        guard let userId = currentUser.Id else {
            return Observable.error(NSError(domain: "PortfolioDaoRepo", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı ID'si bulunamadı."]))
        }

        let query = "SELECT * FROM Exchange WHERE UserId = ?"
        var portfolio: [Exchange] = []

        do {
            guard let database = db else {
                throw NSError(domain: "PortfolioDaoRepo", code: 500, userInfo: [NSLocalizedDescriptionKey: "Veritabanı bağlantısı kurulamadı."])
            }

            let results = try database.executeQuery(query, values: [userId])

            while results.next() {
                let exchange = Exchange(
                    Id: Int(results.int(forColumn: "Id")),
                    Kur: results.string(forColumn: "Kur"),
                    Deger: results.double(forColumn: "Deger"),
                    UserId: Int(results.int(forColumn: "UserId")),
                    AlisFiyati: results.double(forColumn: "AlisFiyati"),
                    Miktar: results.double(forColumn: "Miktar")
                )
                portfolio.append(exchange)
            }

            return Observable.just(portfolio)
        } catch {
            return Observable.error(error)
        }
    }
}
