//
//  HomeViewModel.swift
//  CrazyRecreaction

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    //MARK: - Input
    var fetchData = PublishSubject<Void>()
    var parameterId = BehaviorRelay<String>(value: "0")
    var willLoadData = PublishSubject<Int>()
    
    //MARK: - Output
    var data: Driver<[Datum]> {
        return dataRelay.asDriver()
    }
    
    var isLoding: Driver<Bool> {
        return isLoadingSubject.asDriver()
    }
    
    //MARK: - private
    private var page = BehaviorRelay<Int>(value: 0)
    private var loadData = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var isLoadingSubject = BehaviorRelay<Bool>(value: true)
    private var dataRelay = BehaviorRelay<[Datum]>(value: [])
    
    init() {
        willLoadData
            .map({
                $0 == self.dataRelay.value.count - 1
            })
            .filter({ $0 == true })
            .map({ _ in () })
            .bind(to: fetchData)
            .disposed(by: disposeBag)
        
        page
            .filter({ $0 != 0 })
            .map({ _ in () })
            .bind(to: loadData)
            .disposed(by: disposeBag)
                
        parameterId
            .skip(1)
            .bind { [unowned self](id) in
                self.dataRelay.accept([])
                self.page.accept(1)
            }
            .disposed(by: disposeBag)
        
        fetchData
            .withLatestFrom(page)
            .map({ $0 + 1 })
            .bind(to: page)
            .disposed(by: disposeBag)
        
        loadData
            .flatMapLatest { (_) -> Observable<[Datum]> in
                Observable.create { (subscriber) -> Disposable in
                    let page = self.page.value
                    let id = self.parameterId.value
                    RecreationManager().loadData(page: page, id: id) { [unowned self](result) in
                        switch result {
                        case .success(let data):
                            if let total = data.total, total != 0 {
                                let allData = self.dataRelay.value + (data.data ?? [])
                                subscriber.onNext(allData)
                            } else {
                                self.isLoadingSubject.accept(false)
                                subscriber.onCompleted()
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            subscriber.onError(error)
                        }
                    }
                    return Disposables.create()
                }
            }
            .bind(to: dataRelay)
            .disposed(by: disposeBag)
        
        BehaviorRelay.merge(
            loadData.map({ _ in true }),
            dataRelay.map({ _ in false }))
            .bind(to: isLoadingSubject)
            .disposed(by: disposeBag)
    }
    
    
}
