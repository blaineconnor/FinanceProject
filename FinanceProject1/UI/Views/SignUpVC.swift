//
//  SignUpVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController {
    
    @IBOutlet weak var passwordAgain: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var telefon: UITextField!
    @IBOutlet weak var eposta: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var name: UITextField!
    
    let disposeBag = DisposeBag()
    let signUpVM = SignUpVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [ .font: UIFont(name: "Roboto-Medium", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        guard let ad = name.text,
              let soyad = surname.text,
              let eposta = eposta.text,
              let telefon = telefon.text,
              let kullaniciAdi = username.text,
              let sifre = password.text,
              let sifreTekrar = passwordAgain.text else {
            
            displayAlert(message: "Lütfen tüm alanları doldurun.")
            return
        }
        if sifre != sifreTekrar {
            // Şifreler uyuşmuyor, kullanıcıyı bilgilendir
            displayAlert(message: "Girdiğiniz şifreler uyuşmuyor.")
            return
        }
        
        signUpVM.register(Ad: ad, Soyad: soyad, Eposta: eposta, Telefon: telefon, KullaniciAdi: kullaniciAdi, Sifre: sifre)
            .subscribe(onNext: { success in
                if success {
                    // Kayıt başarılı, otomatik giriş yap
                    self.displayAlert(message: "Kayıt başarıyla tamamlandı!")
                    let signInVM = SignInVM(userDaoRepo: UserDaoRepo())
                    signInVM.login(KullaniciAdi: kullaniciAdi, Sifre: sifre)
                        .subscribe(onNext: { user in
                            if user != nil {
                                // Giriş başarılı, istenen işlemi gerçekleştir (örneğin, tab bar controller'a geçiş yap)
                                if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                                    tabBarController.selectedIndex = 0 // İlk sekmeni seçmek için
                                    UIApplication.shared.windows.first?.rootViewController = tabBarController
                                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                                }
                            } else {
                                // Giriş başarısız, kullanıcıyı bilgilendir
                                self.displayAlert(message: "Kullanıcı adı veya şifre hatalı!")
                            }
                        })
                        .disposed(by: self.disposeBag)
                } else {
                    // Kayıt başarısız, kullanıcıyı bilgilendir
                    self.displayAlert(message: "Kayıt işlemi sırasında bir hata oluştu!")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
