//
//  SearchViewModel.swift
//  CrazyRecreaction

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    //Input
    var searchData = PublishSubject<Void>()
    var selectData = PublishSubject<IndexPath>()
    
    //Output
    var data: Driver<[SelectData]> {
        return dataRelay.asDriver()
    }
    var selectId: Observable<String> {
        return selectIdRelay.asObservable()
    }
    
    //Private
    private var disposeBag = DisposeBag()
    private var dataRelay = BehaviorRelay<[SelectData]>(value: [])
    private var selectIdRelay = BehaviorRelay<String>(value: "0")
    
    init() {
        CreateSelectData().getData()
            .subscribe { [unowned self](data) in
                self.dataRelay.accept(data)
            }
            .disposed(by: disposeBag)
        
        searchData
            .map({ [unowned self](_) -> String in
                var id = ""
                self.dataRelay.value
                    .filter { (selectData) -> Bool in
                        selectData.select == true
                    }.forEach { (selectData) in
                        id += id == "" ? "\(selectData.id)": ",\(selectData.id)"
                    }
                return id
            })
            .bind(to: selectIdRelay)
            .disposed(by: disposeBag)
        
        selectData
            .map { [unowned self](indexPath) -> [SelectData] in
                var changeData: [SelectData] = self.dataRelay.value
                changeData[indexPath.row].select.toggle()
                return changeData
            }
            .bind(to: dataRelay)
            .disposed(by: disposeBag)
            
    }
    
}
