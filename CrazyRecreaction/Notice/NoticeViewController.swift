//
//  NoticeViewController.swift
//  CrazyRecreaction

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NoticeViewController: UIViewController {
    
    //MARK: - UI
    private lazy var noticeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "NoticeTableViewCell", bundle: nil), forCellReuseIdentifier: "NoticeTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var selectDatePickView: SelectDatePickView = {
        let datePick = SelectDatePickView()
        return datePick
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "您尚未加入提醒"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "blank")
        image.contentMode = .scaleAspectFit
        image.alpha = 0.5
        return image
    }()
    
    //MARK: - properties
    var viewModel = NoticeViewModel()
    private var disposeBag = DisposeBag()

    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.fetchAll.onNext(())
        UNUserNotificationCenter.current().getPendingNotificationRequests { (data) in
            print(data)
        }

    }
    
    //MARK: - binding
    private func binding() {
        viewModel.data
            .bind(to: noticeTableView.rx.items(cellIdentifier: "NoticeTableViewCell", cellType: NoticeTableViewCell.self)) {(index, model, cell) in
                cell.update(model)
            }
            .disposed(by: disposeBag)
        
        noticeTableView.rx.modelSelected(UserNotice.self)
            .bind(to: viewModel.selectData)
            .disposed(by: disposeBag)
        
        noticeTableView.rx.modelDeleted(UserNotice.self)
            .bind(to: viewModel.deleteData)
            .disposed(by: disposeBag)
        
        selectDatePickView.close            
            .bind(to: viewModel.closeData)
            .disposed(by: disposeBag)
        
        selectDatePickView.send
            .bind(to: viewModel.sendAction)
            .disposed(by: disposeBag)
        
        viewModel.closeSelectView
            .subscribe { [unowned self](bool) in
                bool ? self.selectDatePickView.closeView(view: self.view): self.selectDatePickView.addTo(view: self.view)
            }
            .disposed(by: disposeBag)
        
        viewModel.emptyIsHidden
            .bind(to: emptyLabel.rx.isHidden)            
            .disposed(by: disposeBag)
    }

}

//MARK: - set up UI
extension NoticeViewController {
    
    private func setupUI() {
        title = "提醒"
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        setTableView()
    }
    
    private func setTableView() {
        view.addSubview(noticeTableView)
        noticeTableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
