//
//  SearchViewController.swift
//  CrazyRecreaction

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    //MARK: - UI
    lazy var selectCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.register(UINib(nibName: "SelectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectCollectionViewCell")
        collectionView.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width / 3 - 15
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = layout
        return collectionView
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "—Pngtree—green_426064")
        image.contentMode = .scaleAspectFit
        image.alpha = 0.5
        return image
    }()
    
    //MARK: - properties
    var viewModel = SearchViewModel()
    var disposeBag = DisposeBag()

    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        viewModel.searchData.onNext(())
    }
    
    //MARK: - set up UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        view.addSubview(selectCollectionView)
        selectCollectionView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        setNavigationButton()
    }
    
    private func setNavigationButton() {
        let searchButton = UIBarButtonItem(title: "搜寻", style: .done, target: self, action: #selector(searchAction))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func searchAction() {        
        navigationController?.popViewController(animated: true)
    }

    //MARK: - viewModel binding
    private func binding() {
        viewModel.data.drive(selectCollectionView.rx.items(cellIdentifier: "SelectCollectionViewCell", cellType: SelectCollectionViewCell.self)) { (index, model, cell) in
            cell.updata(model)
        }
        .disposed(by: disposeBag)
        
        selectCollectionView.rx.itemSelected
            .bind(to: viewModel.selectData)
            .disposed(by: disposeBag)
    }
}

