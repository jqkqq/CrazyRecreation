//
//  HomeTableViewCell.swift
//  CrazyRecreaction

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    //MARK: - IBOulet
    @IBOutlet weak var tourImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(_ data: Datum) {
        tourImageView.kf.setImage(with: URL(string: data.images?.first?.src ?? ""), placeholder: UIImage(named: "placeholder"))
        tourImageView.setupIndicatorType()
        nameLabel.text = data.name
        addressLabel.text = data.address
    }
    
    func update(_ data: RecreationData) {
        tourImageView.kf.setImage(with: URL(string: data.images?.first ?? ""), placeholder: UIImage(named: "placeholder"))
        tourImageView.setupIndicatorType()
        nameLabel.text = data.name
        addressLabel.text = data.address
    }
    
}
