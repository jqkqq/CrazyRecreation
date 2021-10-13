//
//  NoticeTableViewCell.swift
//  CrazyRecreaction

import UIKit

class NoticeTableViewCell: UITableViewCell {
    
    //MARK: - IBOulet
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var recreationImageView: UIImageView!
    
    private var data: UserNotice!
    
    //MARK: - init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(_ data: UserNotice) {
        self.data = data
        openSwitch.isOn = data.isOpen
        nameLabel.text = data.title
        if let time = data.date {
            timeLabel.text = time.replacingOccurrences(of: "00:00", with: "")
        }
        recreationImageView.setupIndicatorType()
        recreationImageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: UIImage(named: "placeholder"))
    }
    
    @IBAction func openSwitchAction(_ sender: UISwitch) {
        let id = data.id ?? ""
        guard let data = UserNoticeManager.shared.fetch(id: id)?.first else {
            return
        }
        UserNoticeManager.shared.edit(data: data, date: data.date ?? "", isOpen: sender.isOn)
        
        if sender.isOn {
            UserNotificationManager().add(title: data.title ?? "", subTitle: data.date ?? "", image: data.image ?? "", id: id)
        } else {
            UserNotificationManager().removeUserNotification(id: [id])
        }
    }
    
}
