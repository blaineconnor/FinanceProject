//
//  SignInVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 12.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SignInVC: UIViewController {

    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var userNameTXT: UITextField!
    
    @IBOutlet weak var passwordTXT: UITextField!
    
    let disposeBag = DisposeBag()
    let signInVM = SignInVM(userDaoRepo: UserDaoRepo())
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 12)
        
        let textField = UITextField()
        textField.font = UIFont(name: "Roboto-Medium", size: 12)
        
        appearance.titleTextAttributes = [ .font: UIFont(name: "Roboto-Medium", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        signInVM.veritabaniKopyala()
           
           setupBindings()
       }
       
       func setupBindings() {
           let usernameValid = userNameTXT.rx.text.orEmpty
               .map { $0.count >= 3 }
           
           let passwordValid = passwordTXT.rx.text.orEmpty
               .map { $0.count >= 6 }
           
           Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
               .bind(to: signInBtn.rx.isEnabled)
               .disposed(by: disposeBag)
           
           signInBtn.rx.tap
               .subscribe(onNext: { [weak self] in
                   guard let self = self else { return }
                   self.signIn()
               })
               .disposed(by: disposeBag)
       }
    
    func signIn() {
        guard let username = userNameTXT.text, let password = passwordTXT.text else { return }

        signInVM.login(KullaniciAdi: username, Sifre: password)
            .subscribe(onNext: { user in
                if user != nil {
                    
                    if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
                        tabBarController.selectedIndex = 0
                        UIApplication.shared.windows.first?.rootViewController = tabBarController
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
                } else {
                
                    let alert = UIAlertController(title: "Hata", message: "Kullanıcı adı veya şifre hatalı!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }


}
