//
//  FavoritesVM.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation
import RxSwift

class FavoritesVM{
    
    private var favoriteForexItems = [Kurlar]()
    private let repo = CurrencyDaoRepo()
        var favorites: BehaviorSubject<[Kurlar]> = BehaviorSubject(value: [])
    
    func toggleFavorite(for kurlar: Kurlar) {
        if let index = favoriteForexItems.firstIndex(where: {$0.forexName == kurlar.forexName}) {
            favoriteForexItems.remove(at: index)
        } else {
            favoriteForexItems.append(kurlar)
        }
    }
    
    func isFavorite(_ forex: Kurlar) -> Bool {
        return favoriteForexItems.contains { $0.forexName == forex.forexName}
    }
    
    
    func getFavorites(forUser userId: Int) -> Observable<[Kurlar]> {
        do {
            try repo.getFavorites(forUser: userId)
            let favoritesList = repo.cur.value
            return Observable.just(try! favoritesList())
        } catch {
            return Observable.error(error)
        }
    }
   
}
