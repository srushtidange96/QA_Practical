//
//  StocksCVCell.swift
//  Quantsapp
//
//  Created by Srushti Dange on 22/07/22.
//

import UIKit

class StocksCVCell: UICollectionViewCell {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imgSymbol:       UIImageView!
    @IBOutlet weak var lblPrice:        UILabel!
    @IBOutlet weak var lblSymbol:       UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
