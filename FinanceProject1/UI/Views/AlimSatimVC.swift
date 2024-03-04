//
//  AlimSatimVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 22.02.2024.
//

import UIKit

protocol CustomAlertDelegate {
    func alSatBtnTapped()
    func closeBtnTapped()
}

class AlimSatimVC: UIViewController, UITextFieldDelegate {
    
    var selectedKur: Kurlar?
    var cur = [Kurlar]()
    var delegate : CustomAlertDelegate? = nil
    private var iTuru: Int?
    
    @IBOutlet weak var alSatBtn: UIButton!
    @IBOutlet var emptySpace: UIView!
    @IBOutlet weak var stepperr: UIStepper!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var degerLbl: UILabel!
    @IBOutlet weak var miktarTF: UITextField!
    @IBOutlet weak var kurLbl: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miktarTF.delegate = self
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        emptySpace.addGestureRecognizer(tapGesture)
        
        alertView.layer.cornerRadius = 10
        alertView.layer.masksToBounds = true
        alertView.layer.borderWidth = 5
        alertView.layer.borderColor = UIColor(hex: "#222E50").cgColor
        
        if let selectedKur = selectedKur {
            configureLbl(withForexName: selectedKur.forexName)
            let selectedIndex = selectedIndexForOperation(selectedKur)
            let buttonText = selectedIndex == 1 ? "Sat" : "Al"
            alSatBtn.setTitle(buttonText, for: .normal)
        }
        
        miktarTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        stepperr.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    
    
    func configureLbl(withForexName forexName: String) {
        kurLbl.text = forexName
    }
    
    
    
    @IBAction func stepper(_ sender: UIStepper) {
        miktarTF.text = "\(Int(sender.value))"
        
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        guard let selectedKur = selectedKur else { return }
        
        let selectedIndex = sender.selectedSegmentIndex
        iTuru = selectedIndex
        var deger: Double = 0.0
        
        if selectedIndex == 0 {
            deger = selectedKur.satis
        } else {
            deger = selectedKur.alis
        }
        
        if let miktarText = miktarTF.text, let miktar = Double(miktarText) {
            let toplamDeger = miktar * deger
            degerLbl.text = String(format: "%.2f", toplamDeger)
        }
        
        let buttonText = selectedIndex == 1 ? "Sat" : "Al"
        alSatBtn.setTitle(buttonText, for: .normal)
    }
    
    @IBAction func alSat(_ sender: Any) {
        guard let selectedKur = selectedKur,
                let miktarText = miktarTF.text,
                let miktar = Double(miktarText),
                let userId = SessionManager.shared.getCurrentUser()?.Id else {
              return
          }
          
        guard let selectedIndex = iTuru else { return }
        
          
          var message = ""
          if selectedIndex == 0 {
              message = "Emin misiniz? Almak istediğiniz miktar: \(miktar)"
          } else {
              message = "Emin misiniz? Satmak istediğiniz miktar: \(miktar)"
          }
          
          let alertController = UIAlertController(title: "Onay", message: message, preferredStyle: .alert)
        
        if selectedIndex == 0 {
            let alAction = UIAlertAction(title: "Al", style: .default) { _ in
                self.executeTransaction(selectedIndex: selectedIndex, selectedKur: selectedKur, miktar: miktar, userId: userId)
            }
            let vazgecAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
            
            alertController.addAction(alAction)
            alertController.addAction(vazgecAction)
        } else {
            let satAction = UIAlertAction(title: "Sat", style: .default) {_ in 
                self.executeTransaction(selectedIndex: selectedIndex, selectedKur: selectedKur, miktar: miktar, userId: userId)
            }
            let vazgecAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
            
            alertController.addAction(satAction)
            alertController.addAction(vazgecAction)
        }
          
          
          present(alertController, animated: true, completion: nil)
      }

    func executeTransaction(selectedIndex: Int, selectedKur: Kurlar, miktar: Double, userId: Int) {
        var isSuccess = false
        let alisFiyati = selectedKur.alis
        let satisFiyati = selectedKur.satis
        
        if selectedIndex == 0 {
            isSuccess = AlSatVM().alKur(ekschange: convertToExchange(from: selectedKur), miktar: miktar, alisFiyati: alisFiyati, userId: userId)
        } else {
            isSuccess = AlSatVM().satKur(ekschange: convertToExchange(from: selectedKur), miktar: miktar, satisFiyati: satisFiyati, userId: userId)
        }
        
        if isSuccess {
            showAlert(title: "Başarılı", message: "İşlem başarıyla tamamlandı.")
        } else {
            showAlert(title: "Hata", message: "İşlem gerçekleştirilemedi.")
        }
    }
    
    func performTransaction(selectedIndex: Int, selectedKur: Kurlar, miktar: Double, alisFiyati: Double, satisFiyati: Double, userId: Int) {
        if selectedIndex == 0 {
            let isSuccess = AlSatVM().alKur(ekschange: convertToExchange(from: selectedKur), miktar: miktar, alisFiyati: alisFiyati, userId: userId)
            if isSuccess {
                showAlert(title: "Başarılı", message: "Alım işlemi başarıyla tamamlandı.")
            } else {
                showAlert(title: "Hata", message: "Alım işlemi gerçekleştirilemedi. Yetersiz bakiye veya geçersiz miktar.")
            }
        } else {
            let isSuccess = AlSatVM().satKur(ekschange: convertToExchange(from: selectedKur), miktar: miktar, satisFiyati: satisFiyati, userId: userId)
            if isSuccess {
                showAlert(title: "Başarılı", message: "Satış işlemi başarıyla tamamlandı.")
            } else {
                showAlert(title: "Hata", message: "Satış işlemi gerçekleştirilemedi. Yetersiz varlık veya geçersiz miktar.")
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func convertToExchange(from kurlar: Kurlar) -> Exchange {
        return Exchange(Id: kurlar.sira, Kur: kurlar.forexName, Deger: 0.0, UserId: 0, AlisFiyati: kurlar.alis, Miktar: 0.0)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            stepperr.value = value
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let tappedPoint = gesture.location(in: view)
        if !alertView.frame.contains(tappedPoint) {
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func selectedIndexForOperation(_ selectedKur: Kurlar) -> Int {
        return selectedKur.satis < selectedKur.alis ? 1 : 0
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let selectedKur = selectedKur, var miktarText = textField.text, !miktarText.isEmpty else {
            return
        }
        
        if let dotIndex = miktarText.firstIndex(of: ".") {
            let decimalPart = miktarText.suffix(from: dotIndex)
            if decimalPart.count > 3 {
                let truncatedDecimalPart = decimalPart.prefix(4)
                miktarText = String(miktarText.prefix(upTo: dotIndex)) + truncatedDecimalPart
            }
        }
        
        textField.text = miktarText
        
        if let miktar = Double(miktarText) {
            let selectedIndex = selectedIndexForOperation(selectedKur)
            let deger = selectedIndex == 0 ? selectedKur.satis : selectedKur.alis
            let toplamDeger = miktar * deger
            degerLbl.text = String(format: "%.2f", toplamDeger)
        }
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        miktarTF.text = "\(Int(sender.value))"
        
        textFieldDidChange(miktarTF)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
