//
//  ChangePasswordVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 15.02.2024.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var yeniSifreTekrar: UITextField!
    @IBOutlet weak var yeniSifre: UITextField!
    @IBOutlet weak var eskiSifre: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [ .font: UIFont(name: "Roboto-Medium", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
  
    }
    
    @IBAction func degistirBtn(_ sender: Any) {
          guard let eskiSifre = eskiSifre.text,
                let yeniSifre = yeniSifre.text,
                let yeniSifreTekrar = yeniSifreTekrar.text else {
              
              showAlert(message: "Lütfen tüm alanları doldurun.")
              return
          }
        
          if yeniSifre != yeniSifreTekrar {
              showAlert(message: "Yeni şifreler eşleşmiyor.")
              return
          }
          
          guard var currentUser = SessionManager.shared.getCurrentUser() else {
         
              showAlert(message: "Oturum açılmamış.")
              return
          }
          
          if eskiSifre != currentUser.Sifre {
          
              showAlert(message: "Eski şifre yanlış.")
              return
          }
          
          if yeniSifre == eskiSifre {
              showAlert(message: "Yeni şifre eski şifre ile aynı olamaz.")
              return
          }
          
          currentUser.Sifre = yeniSifre
        
        let userDaoRepo = UserDaoRepo()
        userDaoRepo.updatePassword(userId: currentUser.Id!, newPassword: yeniSifre)
         
          SessionManager.shared.setCurrentUser(user: currentUser)
          
          showAlert(message: "Şifre başarıyla değiştirildi.")
      }
      
      private func showAlert(message: String) {
          let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
          present(alertController, animated: true, completion: nil)
      }
    
}
