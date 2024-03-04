//
//  Exchange.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 23.02.2024.
//

struct Exchange {
    var Id: Int?
    var Kur: String?
    var Deger: Double?
    var UserId: Int?
    var AlisFiyati: Double?
    var Miktar:Double?

    init(Id: Int?, Kur: String?, Deger: Double?, UserId: Int?, AlisFiyati: Double?, Miktar: Double?) {
        self.Id = Id
        self.Kur = Kur
        self.Deger = Deger
        self.UserId = UserId
        self.AlisFiyati = AlisFiyati
        self.Miktar = Miktar
    }
}
