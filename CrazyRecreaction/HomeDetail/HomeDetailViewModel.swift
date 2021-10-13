//
//  HomeDetailViewModel.swift
//  CrazyRecreaction

import Foundation
import RxSwift
import RxCocoa

class HomeDetailViewModel {
    
    //Input
    var deleteLove = PublishSubject<Void>()
    var addLove = PublishSubject<Void>()
    var checkData = PublishSubject<Void>()
    
    //Output
    var data: Observable<Datum?> {
        return dataRelay.asObservable()
    }
    var isLove: Observable<Bool> {
        return isLoveSubject.asObservable()
    }
    var addAlert: Observable<Bool?> {
        return addAlertSubject.asObservable()
    }
    
    //Private
    private var disposeBag = DisposeBag()
    private var dataRelay = BehaviorRelay<Datum?>(value: nil)
    private var isLoveSubject = PublishSubject<Bool>()
    private var addAlertSubject = PublishSubject<Bool?>()
    
    init() {        
        deleteLove
            .do(onNext: { (_) in
                let data = self.dataRelay.value
                if let recreationData = RecreationDataManager.shared.fetch()?.filter({
                    $0.name == data?.name
                }).first {
                    RecreationDataManager.shared.delete(recreationData)
                }
            })
            .map({ _ in false })
            .bind(to: isLoveSubject)
            .disposed(by: disposeBag)
        
        addLove
            .do(onNext: { (_) in
                guard let data = self.dataRelay.value else { return }
                RecreationDataManager.shared.add(data)
            })
            .map({ _ in true })
            .bind(to: isLoveSubject)
            .disposed(by: disposeBag)
                    
        checkData
            .map { (_) -> Bool? in
                guard let data = self.dataRelay.value,
                      let addDatas = RecreationDataManager.shared.fetch()?.filter({
                    data.name == $0.name
                }) else { return nil }
                return !addDatas.isEmpty
            }
            .filter({ $0 != nil })
            .bind(to: addAlertSubject)
            .disposed(by: disposeBag)

    }
    
    func setData(_ data: Datum) {
        self.dataRelay.accept(data)
        if let isNotLove = RecreationDataManager.shared.fetch()?.filter({
            data.name == $0.name
        }).isEmpty {
            isLoveSubject.onNext(!isNotLove)
        }
    }

}
