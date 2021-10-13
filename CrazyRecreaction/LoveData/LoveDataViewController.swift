//
//  LoveDataViewController.swift
//  CrazyRecreaction

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoveDataViewController: UIViewController {
    
    //MARK: UI
    lazy var loveDataTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "—Pngtree—warm tones gouache background_1011131")
        image.contentMode = .scaleAspectFill
        image.alpha = 0.5
        return image
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "您尚未加入资料"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    //MARK: - viewModel
    var viewModel = LoveDataViewModel()
    var disposeBag = DisposeBag()

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.fetchData.onNext(())        
    }
    
    //MARK: - set up UI
    private func setupUI() {
        title = "我的最愛"
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.addSubview(loveDataTableView)
        loveDataTableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    //MARK: - binding
    private func binding() {
        viewModel.data
            .bind(to: loveDataTableView.rx.items(cellIdentifier: "HomeCell", cellType: HomeTableViewCell.self)) { (index, model, cell) in
                cell.update(model)
            }
            .disposed(by: disposeBag)
        
        loveDataTableView.rx
            .modelSelected(RecreationData.self).subscribe(onNext: { [unowned self](recreationData) in
                let vc = HomeDetailViewController()
                vc.data = self.viewModel.changeToRecreation(recreationData)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.emptyString
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    
}
