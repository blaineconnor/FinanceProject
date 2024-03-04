//
//  SignUpVM.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import Foundation
import RxSwift

struct SignUpVM{
    
    let userDaoRepo = UserDaoRepo()
       
       func register(Ad: String, Soyad: String, Eposta: String, Telefon: String, KullaniciAdi: String, Sifre: String) -> Observable<Bool> {
           return Observable.create { observer in
               self.userDaoRepo.insert(Ad: Ad, Soyad: Soyad, Eposta: Eposta, Telefon: Telefon, KullaniciAdi: KullaniciAdi, Sifre: Sifre)
               observer.onNext(true)
               observer.onCompleted()
               return Disposables.create()
           }
           .flatMap { (success: Bool) -> Observable<User?> in
               if success {
                   
                   let signInVM = SignInVM(userDaoRepo: self.userDaoRepo)
                   return signInVM.login(KullaniciAdi: KullaniciAdi, Sifre: Sifre)
                       .map { user -> User? in
                           if let user = user {
                               SessionManager.shared.setCurrentUser(user: user)
                           }
                       return user
                       }
               } else {
                   return Observable.just(nil)
               }
           }
           .map { user -> Bool in
           
               return user != nil
           }
       }   
   
}
