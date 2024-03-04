//
//  AlSatVM.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 23.02.2024.
//

import RxSwift

class AlSatVM {
    private let alSatRepo = AlSatDaoRepo()

    func alKur(ekschange: Exchange, miktar: Double, alisFiyati: Double, userId: Int) -> Bool {
            return alSatRepo.buyExchange(kur: ekschange.Kur ?? "", miktar: miktar, alisFiyati: alisFiyati, userId: userId)
        }
        
        func satKur(ekschange: Exchange, miktar: Double, satisFiyati: Double, userId: Int) -> Bool {
            return alSatRepo.sellExchange(kur: ekschange.Kur ?? "", miktar: miktar, satisFiyati: satisFiyati, userId: userId)
        }
}
