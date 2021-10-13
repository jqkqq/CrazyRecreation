//
//  HomeViewController.swift
//  CrazyRecreaction

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class HomeViewController: UIViewController {
    
    //MARK: UIKik
    private lazy var homeTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var activityView: NVActivityIndicatorView = {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let view = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: .darkGray)        
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "—Pngtree—green_426064")
        image.contentMode = .scaleAspectFill
        image.alpha = 0.5
        return image
    }()

    //MARK: - properties
    var viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        binding()
        viewModel.fetchData.onNext(())        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    //MARK: - set up UI
    private func setUpUI() {
        title = "旅游景点"
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.addSubview(activityView)
        activityView.snp.makeConstraints({
            $0.width.height.equalTo(50)
            $0.center.equalToSuperview()
        })
        
        let searchButton = UIBarButtonItem(title: "筛选种类", style: .done, target: self, action: #selector(goToSearchVC))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func goToSearchVC() {
        let vc = SearchViewController()
        vc.viewModel.selectId
            .bind(to: viewModel.parameterId)
            .disposed(by: disposeBag)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - viewModel binding
    private func binding() {
        viewModel.data
            .drive(homeTableView.rx.items(cellIdentifier: "HomeCell", cellType: HomeTableViewCell.self)) { (index, model, cell) in
                cell.update(model)
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoding
            .drive(activityView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        homeTableView.rx.willDisplayCell
            .map({ $0.indexPath.row })
            .bind(to: viewModel.willLoadData)
            .disposed(by: disposeBag)
        
        homeTableView.rx
            .modelSelected(Datum.self).subscribe { [unowned self](recreation) in
                if let data = recreation.element {
                    let vc = HomeDetailViewController()
                    vc.data = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
    }

}


