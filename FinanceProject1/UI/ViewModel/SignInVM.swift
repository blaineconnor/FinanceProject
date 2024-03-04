//
//  SignInVM.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation
import RxSwift

struct SignInVM{
    
    var userDaoRepo: UserDaoRepo
        
    init(userDaoRepo: UserDaoRepo) {
        self.userDaoRepo = userDaoRepo
    }
        
    func login(KullaniciAdi: String, Sifre: String) -> Observable<User?> {
        userDaoRepo.login(kullaniciAdi: KullaniciAdi, sifre: Sifre)
            .map{ user -> User? in
                if let user = user {
                    SessionManager.shared.setCurrentUser(user: user)
                }
            return user
            }
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
}
