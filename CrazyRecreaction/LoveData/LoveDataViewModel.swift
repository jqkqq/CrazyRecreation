//
//  LoveDataViewModel.swift
//  CrazyRecreaction

import Foundation
import RxSwift
import RxCocoa

class LoveDataViewModel {
    //MARK: -Input
    var fetchData = PublishSubject<Void>()

    //MARK: - Output
    var data: Observable<[RecreationData]> {
        return dataRelay.asObservable()
    }
    var emptyString: Observable<Bool> {
        return emptyStringRelay.asObservable()
    }
    
    //private
    private var disposeBag = DisposeBag()
    private var dataRelay = BehaviorRelay<[RecreationData]>(value: [])
    private var emptyStringRelay = BehaviorRelay<Bool>(value: false)
    
    init() {
        fetchData
            .map({
                guard let data = RecreationDataManager.shared.fetch() else { return [] }
                return data
            })
            .bind(to: dataRelay)
            .disposed(by: disposeBag)
        
        data
            .map({ $0.count != 0 })
            .bind(to: emptyStringRelay)
            .disposed(by: disposeBag)
    }
    
    //MARK: - function    
    func changeToRecreation(_ data: RecreationData) -> Datum {
        var images = [Image]()
        data.images?.forEach({
            images.append(Image(src: $0, subject: nil, ext: nil))
        })
        return Datum(id: nil, name: data.name, nameZh: nil, openStatus: nil, introduction: data.introduction, openTime: data.openTime, zipcode: data.zipcode, distric: nil, address: data.address, tel: nil, fax: nil, email: nil, months: nil, nlat: nil, elong: nil, officialSite: nil, facebook: nil, ticket: nil, remind: nil, staytime: nil, modified: nil, url: data.url, category: nil, target: nil, service: nil, images: images)
    }
}
