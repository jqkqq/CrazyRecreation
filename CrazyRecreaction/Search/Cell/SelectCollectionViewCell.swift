//
//  SelectCollectionViewCell.swift
//  CrazyRecreaction

import UIKit

class SelectCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectView.layer.cornerRadius = 10
    }

    func updata(_ data: SelectData) {
        selectNameLabel.text = data.name
        selectView.backgroundColor = data.select ? .systemGreen: .gray
    }
}

