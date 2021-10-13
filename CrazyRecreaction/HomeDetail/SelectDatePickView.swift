//
//  SelectDatePickVIew.swift
//  CrazyRecreaction

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SelectDatePickView: UIView {
    
    //MARK: - UI
    lazy var datePickView: UIDatePicker = {
        let datePick = UIDatePicker()
        datePick.datePickerMode = .date
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        datePick.date = tomorrow
        datePick.minimumDate = tomorrow
        return datePick
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "請選擇要提醒的時間"
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("確認", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("取消", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()
    
    var close = PublishSubject<Void>()
    var send = PublishSubject<String>()

    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }

    private func setupUI() {
        backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        layer.cornerRadius = 10
      
        addSubview(datePickView)
        datePickView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        })
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(datePickView.snp.top)
        })
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(sendButton)
        addSubview(stackView)
        
        stackView.snp.makeConstraints({
            $0.top.equalTo(datePickView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        })
    }
    
    func addTo(view: UIView) {
        self.transform = CGAffineTransform(rotationAngle: .zero)
        self.frame = CGRect(x: view.frame.size.width * 0.1 , y: view.frame.size.height, width: view.frame.size.width * 0.8, height: view.frame.size.height * 0.3)
        view.addSubview(self)
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x: (view.frame.size.width - self.frame.width) / 2, y: (view.frame.size.height - self.frame.height) / 2 , width: view.frame.size.width * 0.8, height: view.frame.size.height * 0.3)
        }
    }
    
    func closeView(view: UIView) {
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect(x: view.frame.size.width * 0.1 , y: view.frame.size.height, width: view.frame.size.width * 0.8, height: view.frame.size.height * 0.3)
            self.transform = CGAffineTransform(rotationAngle: .pi/10)
        } completion: { (_) in
            
            self.removeFromSuperview()            
        }
    }
    
    @objc private func cancelAction() {
        close.onNext(())
    }
    
    @objc private func sendAction() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy 00:00"        
        let time = formatter.string(from: datePickView.date)        
        send.onNext(time)
    }
    
}




