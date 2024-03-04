//
//  FavoritesTVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 19.02.2024.
//

import UIKit

class FavoritesTVC: UITableViewCell {

    @IBOutlet weak var satisLbl: UILabel!
    @IBOutlet weak var alisLbl: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var kurLbl: UILabel!
    
    var isStarred = false // Favori durumu
        
        func configureCell(withForexName forexName: String, alis: String, satis: String, isFavorite: Bool) {
            kurLbl.text = forexName
            alisLbl.text = "Alış: \(alis)"
            satisLbl.text = "Satış: \(satis)"
            updateFavoriteButton(isFavorite: isFavorite)
        }
        
        func updateFavoriteButton(isFavorite: Bool) {
            isStarred = isFavorite
            let imageName = isFavorite ? "starred" : "star"
            favBtn.setImage(UIImage(named: imageName), for: .normal)
        }
    
    @IBAction func favBtnTapped(_ sender: Any) {
        isStarred.toggle()
        updateFavoriteButton(isFavorite: isStarred)
        
    }
    
}
