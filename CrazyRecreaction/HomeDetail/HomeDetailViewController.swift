//
//  HomeDetailViewController.swift
//  CrazyRecreaction

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import SCLAlertView
import FSPagerView

class HomeDetailViewController: UIViewController {
    
    //MARK: - UI
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var recreationFSPagerView: FSPagerView = {
        let fsPagerView = FSPagerView()
        fsPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        fsPagerView.dataSource = self
        fsPagerView.delegate = self
        return fsPagerView
    }()
    
    lazy var recreationFSpageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = data?.images?.count ?? 0
        pageControl.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return pageControl
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(25)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.9820066094, green: 0.8159198165, blue: 0.2591892183, alpha: 1)
        return label
    }()
    
    lazy var noticeButton: UIButton = {
        let button = UIButton()
        button.setTitle("设定通知", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .white
        return button
    }()
    
    lazy var dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var selectDatePickView: SelectDatePickView = {
        let datePick = SelectDatePickView()        
        return datePick
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "—Pngtree—green_426064")
        image.contentMode = .scaleAspectFill
        image.alpha = 0.5
        return image
    }()
    
    //MARK: - properties
    var viewModel = HomeDetailViewModel()
    private let disposeBag = DisposeBag()
    var data: Datum?
    
    //MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        binding()
        viewModel.setData(data!)
    }
    
    func alert(_ delete: Bool) {
        let alert = SCLAlertView()
        let content = delete ? "刪除": "加入"
        alert.addButton("確認") { [unowned self] in
            delete ?
                self.viewModel.deleteLove.onNext(()): self.viewModel.addLove.onNext(())
        }
        alert.showEdit("提示", subTitle: "是否\(content)我的最愛", closeButtonTitle: "取消")
    }
    
    //MARK: - viewModel binding
    private func binding() {
        viewModel.data
            .filter({ $0 != nil })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self](data) in
                self.setLabel(data?.name ?? "")
                self.setCustomStackView(title: "郵政區碼", detail: data?.zipcode ?? "")
                self.setCustomStackView(title: "地區", detail: data?.distric ?? "")
                self.setCustomStackView(title: "地址", detail: data?.address ?? "")
                self.setCustomStackView(title: "營業時間", detail: data?.openTime ?? "")
                self.addOpenUrl(title: "網址", url: data?.url ?? "")
                self.addLabelToStackView("介紹", background: #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
                self.addLabelToStackView(data?.introduction ?? "")
                self.setButton()
                self.setStackView()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLove
            .subscribe(onNext: { [unowned self] bool in
                let shareButton = navigationItem.rightBarButtonItems?.filter({
                    $0.title != "分享"
                }).first
                shareButton?.title = bool ? "❤️": "🤍"
            })
            .disposed(by: disposeBag)
        
        viewModel.addAlert
            .subscribe(onNext: { [unowned self] bool in
                guard let bool = bool else { return }
                self.alert(bool)
            })
            .disposed(by: disposeBag)
        
        selectDatePickView.close
            .subscribe { [unowned self](_) in
                self.selectDatePickView.removeFromSuperview()
            }
            .disposed(by: disposeBag)
        
        selectDatePickView.send
            .subscribe { [unowned self](time) in
                print(time.element ?? "")
                UserNotificationManager().add(title: data?.name ?? "", subTitle: time.element ?? "", image: data?.images?.first?.src ?? "")
                self.selectDatePickView.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - set up UI
extension HomeDetailViewController {
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        setScrollView()
        setLabel("Error")
        setFSPagerView()
        setFSPageControl()
        setShareButton()
    }
    
    private func setShareButton() {
        let shareButton = UIBarButtonItem(title: "分享", style: .done, target: self, action: #selector(shareAction))
        let addButton = UIBarButtonItem(title: "🤍", style: .done, target: self, action: #selector(checkIsLove))
        navigationItem.rightBarButtonItems = [shareButton, addButton]
    }
    
    @objc func checkIsLove() {
        viewModel.checkData.onNext(())
    }
    
    @objc func shareAction() {
        let string = """
        \(data?.name ?? "")

        \(data?.address ?? "")

        \(data?.officialSite ?? "")

        \(data?.introduction ?? "")
        """
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: data?.images?.first?.src ?? ""), placeholder: UIImage(named: "placeholder"))
        let items: [Any] = [imageView as Any, string]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    private func setButton() {
        dataStackView.addArrangedSubview(noticeButton)
        noticeButton.addTarget(self, action: #selector(noticeAction), for: .touchUpInside)
    }
    
    @objc func noticeAction() {
        selectDatePickView.addTo(view: view)
    }
    
    private func setScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview()
        })
    }
    
    private func setFSPageControl() {
        scrollView.addSubview(recreationFSpageControl)
        recreationFSpageControl.snp.makeConstraints({
            $0.top.equalTo(recreationFSPagerView.snp.bottom)
            $0.height.equalTo(10)
            $0.width.equalTo(recreationFSPagerView)
            $0.centerX.equalToSuperview()
        })
    }
    
    private func setFSPagerView() {
        scrollView.addSubview(recreationFSPagerView)
        recreationFSPagerView.snp.makeConstraints({
            $0.left.right.equalToSuperview().offset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.width.equalToSuperview().offset(-40)
            $0.height.equalToSuperview().multipliedBy(0.4)
        })
    }
    
    private func setLabel(_ title: String) {
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({
            $0.width.equalToSuperview().dividedBy(1.2)
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        })
        titleLabel.text = title
    }
    
    private func setStackView() {
        scrollView.addSubview(dataStackView)
        dataStackView.snp.makeConstraints({
            $0.top.equalTo(recreationFSpageControl.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().offset(10)
            $0.width.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-10)
        })
    }
    
    //MARK: function
    private func setCustomStackView(title: String, detail: String) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        let titleLabel = UILabel()
        let detailLabel = UILabel()
        titleLabel.text = title
        detailLabel.text = detail
        [titleLabel, detailLabel].forEach({
            $0.font = $0.font.withSize(20)
            $0.textAlignment = .center
            $0.layer.borderWidth = 1
            $0.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            $0.numberOfLines = 100
            stackView.addArrangedSubview($0)
        })
        titleLabel.snp.makeConstraints({
            $0.width.equalTo(detailLabel).dividedBy(2)
        })
        dataStackView.addArrangedSubview(stackView)
    }
    
    func addLabelToStackView(_ content: String, background: UIColor? = nil) {
        let label = UILabel()
        label.numberOfLines = 100
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.text = content
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        label.backgroundColor = background ?? .white
        dataStackView.addArrangedSubview(label)
    }
    
    func addOpenUrl(title: String, url: String) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        let titleLabel = UILabel()
        let button = UIButton()
        button.isEnabled = true
        titleLabel.text = title
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        [titleLabel, button].forEach({
            $0.layer.borderWidth = 1
            $0.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            stackView.addArrangedSubview($0)
        })
        titleLabel.font = titleLabel.font.withSize(20)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints({
            $0.width.equalTo(button).dividedBy(2)
        })
        
        let attributes: [NSAttributedString.Key: Any] = [
              .font: UIFont.systemFont(ofSize: 14),
              .foregroundColor: UIColor.blue,
              .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: url, attributes: attributes)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(openUrlAction), for: .touchUpInside)
        dataStackView.addArrangedSubview(stackView)
    }
    
    @objc func openUrlAction() {
        if let url = URL(string: data?.url ?? "") {
            UIApplication.shared.open(url)
        }
    }
}

//MARK: - FSPagerViewDataSource and delegate
extension HomeDetailViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return data?.images?.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let data = self.data?.images?[index].src ?? ""
        cell.imageView?.setupIndicatorType()
        cell.imageView?.kf.setImage(with: URL(string: data), placeholder: UIImage(named: "placeholder"))
        cell.contentMode = .scaleAspectFit
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        recreationFSpageControl.currentPage = targetIndex
    }
}
