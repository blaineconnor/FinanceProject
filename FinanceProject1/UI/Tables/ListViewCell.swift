//
//  ListViewCell.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 12.02.2024.
//

import UIKit

class ListViewCell: UITableViewCell {

    @IBOutlet weak var lblForexName: UILabel!
    @IBOutlet weak var lblAlis: UILabel!
    @IBOutlet weak var lblSatis: UILabel!
    
    var lbl:String = " "
    var lbl0:String = " "
    var lbl1:String = " "
    override func awakeFromNib() {
        super.awakeFromNib()
        lblForexName.text = lbl
        lblAlis.text = lbl0
        lblSatis.text = lbl1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(withForexName forexName: String, alis: String, satis: String) {
        lblForexName.text = forexName
        lblAlis.text = "A: \(alis)"
        lblSatis.text = "S: \(satis)"
    }
}
