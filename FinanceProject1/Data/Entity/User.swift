//
//  User.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

struct User {
    var Id: Int?
    var Ad: String?
    var Soyad: String?
    var Eposta: String?
    var Telefon: String?
    var KullaniciAdi: String?
    var Sifre: String?
    var Bakiye: Double?
    
    init() {
    }

    init(Id: Int?, Ad: String?, Soyad: String?, Eposta: String?, Telefon: String?, KullaniciAdi: String?, Sifre: String?, Bakiye: Double?) {
        self.Id = Id
        self.Ad = Ad
        self.Soyad = Soyad
        self.Eposta = Eposta
        self.Telefon = Telefon
        self.KullaniciAdi = KullaniciAdi
        self.Sifre = Sifre
        self.Bakiye = Bakiye
    }
}


