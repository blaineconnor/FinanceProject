//
//  GridViewCell.swift
//  FinanceProject1
//
//  Created by Fatih Emre Sarman on 12.02.2024.
//

import UIKit

class GridViewCell: UICollectionViewCell {
    @IBOutlet weak var lblString: UILabel!
    @IBOutlet weak var lblSatis: UILabel!
    @IBOutlet weak var lblAlis: UILabel!
    
    var lbl:String = " "
    var lbl0:String = " "
    var lbl1:String = " "
    override func awakeFromNib() {
        super.awakeFromNib()
        lblString.text = lbl
        lblAlis.text = lbl0
        lblSatis.text = lbl1
    }
    func configureCell(withForexName forexName: String, alis: String, satis: String) {
        lblString.text = forexName
        lblAlis.text = "A: \(alis)"
        lblSatis.text = "S: \(satis)"
    }
    
}
