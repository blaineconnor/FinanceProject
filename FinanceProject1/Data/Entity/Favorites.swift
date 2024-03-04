//
//  Favorites.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 22.02.2024.
//

import Foundation

struct Favorites{
    var Id:Int?
    var forexName:String?
    var UserId:Int?
    var Alis:Double?
    var Satis:Double?
    
    init(){
        
    }
    
    init(Id: Int, forexName: String, UserId: Int, Alis: Double, Satis: Double) {
        self.Id = Id
        self.forexName = forexName
        self.UserId = UserId
        self.Alis = Alis
        self.Satis = Satis
    }
}
