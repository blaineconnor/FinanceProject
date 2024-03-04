//
//  PortfolioTVC.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 15.02.2024.
//

import UIKit

class PortfolioTVC: UITableViewCell {

    @IBOutlet weak var kurLbl: UILabel!
    @IBOutlet weak var miktarLbl: UILabel!
    @IBOutlet weak var degerLbl: UILabel!
    
    func configureCell(withForexName Kur: String, Miktar: String, Deger: String) {
        kurLbl.text = Kur
        miktarLbl.text = Miktar
        degerLbl.text = Deger
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
