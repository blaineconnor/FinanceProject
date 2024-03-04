//
//  UserListViewCell.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 20.02.2024.
//

import UIKit

class UserListViewCell: UITableViewCell {

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var lblForexName: UILabel!
    @IBOutlet weak var lblAlis: UILabel!
    @IBOutlet weak var lblSatis: UILabel!
    
    
    var isStarred = false
    var lbl:String = " "
    var lbl0:String = " "
    var lbl1:String = " "
    override func awakeFromNib() {
        super.awakeFromNib()
        lblForexName.text = lbl
        lblAlis.text = lbl0
        lblSatis.text = lbl1
        
        favBtn.setImage(.star, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(withForexName forexName: String, alis: String, satis: String) {
        lblForexName.text = "\(forexName)"
        lblAlis.text = "A: \(alis)"
        lblSatis.text = "S: \(satis)"
    }
 
    func updateFavoriteButton(){
        let imgName = isStarred ? "starred" : "star"
        favBtn.setImage(UIImage(named: imgName), for: .normal)
    }
    
    @IBAction func favButton(_ sender: Any) {
        isStarred.toggle()
        updateFavoriteButton()
    }
}
