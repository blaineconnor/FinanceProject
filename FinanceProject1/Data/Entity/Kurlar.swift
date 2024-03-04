//
//  Kurlar.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation

struct Kurlar: Codable{
    let sira: Int
    let forexName, kurAdi: String
    let alis, satis: Double
    let updateTime: String
    let isFavorite: Bool?
    

    
    init(sira: Int, forexName: String, kurAdi: String, alis: Double, satis: Double, updateTime: String, isFavorite:Bool?) {
        self.sira = sira
        self.forexName = forexName
        self.kurAdi = kurAdi
        self.alis = alis
        self.satis = satis
        self.updateTime = updateTime
        self.isFavorite = isFavorite
    }
    
    enum CodingKeys: String, CodingKey {
        case sira = "Sira"
        case forexName
        case kurAdi = "KurAdi"
        case alis = "Alis"
        case satis = "Satis"
        case updateTime = "UpdateTime"
        case isFavorite
    }
   
}


struct KurlarResponse: Codable {
    let kurlar: [Kurlar]
    let hataKodu: Int
    let hataMesaji: String
    let rowID: Int

    enum CodingKeys: String, CodingKey {
        case kurlar = "Kurlar"
        case hataKodu = "HataKodu"
        case hataMesaji = "HataMesaji"
        case rowID = "RowId"
    }
}

