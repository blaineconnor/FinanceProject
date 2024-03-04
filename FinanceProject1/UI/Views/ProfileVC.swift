//
//  ProfileVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 13.02.2024.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var telefonLbl: UILabel!
    @IBOutlet weak var epostaLbl: UILabel!
    @IBOutlet weak var soyadLbl: UILabel!
    @IBOutlet weak var adLbl: UILabel!
    @IBOutlet weak var kullaniciAdiLbl: UILabel!
    @IBOutlet weak var bakiyeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        
        appearance.titleTextAttributes = [ .font: UIFont(name: "Roboto-Medium", size: 22)!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
       
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          displayUserProfile()
      }
    
    
    private func displayUserProfile() {
        if let currentUser = SessionManager.shared.getCurrentUser() {
            adLbl.text = currentUser.Ad
            soyadLbl.text = currentUser.Soyad
            epostaLbl.text = currentUser.Eposta
            telefonLbl.text = currentUser.Telefon
            kullaniciAdiLbl.text = currentUser.KullaniciAdi
            
            if let bakiye = currentUser.Bakiye {
                       bakiyeLbl.text = "\(bakiye)"
                   }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Çıkış Yap", message: "Emin misiniz?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Evet", style: .default, handler: { _ in
           
            SessionManager.shared.clearCurrentUser()
           
            if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") {
                UIApplication.shared.windows.first?.rootViewController = mainVC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }))
        
     
        alertController.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
