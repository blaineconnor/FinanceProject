//
//  MainVM.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation
import RxSwift

struct MainVM{
    
    var cRepo = CurrencyDaoRepo()
    var cur = BehaviorSubject<[Kurlar]>(value: [Kurlar]())
    var kurlar : [Kurlar] = []
    
    init(){
        
        veritabaniKopyala()
        cur = cRepo.cur
    }
    
   
    
    func veritabaniKopyala(){
        let bundleYolu = Bundle.main.path(forResource: "finance", ofType: ".sqlite")
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("finance.sqlite")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: kopyalanacakYer.path){print("Veritabanı zaten var.")
        }else{
            do{
                try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
            }catch{}
        }
    }
    
    func getToken(/*private*/ completion: @escaping (Result<String, Error>) -> Void) {
        HttpConn.getToken(/*private*/) { token in
            completion(.success(token.token))
        }
    }
    
    func getKurListe(token: String, completion: @escaping (Result<[Kurlar], Error>) -> Void) {
        HttpConn.getKurListe(token: token) { result in
            switch result {
            case .success(let kurlar):
                completion(.success(kurlar))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
