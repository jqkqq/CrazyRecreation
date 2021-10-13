//
//  NoticeViewModel.swift
//  CrazyRecreaction

import Foundation
import RxSwift
import RxCocoa
import UserNotifications

class NoticeViewModel {
    
    //Input
    var fetchAll = PublishSubject<Void>()
    var deleteData = PublishSubject<UserNotice>()
    var sendAction = PublishSubject<String>()
    var selectData = BehaviorRelay<UserNotice?>(value: nil)
    var closeData = PublishSubject<Void>()
    
    //Output
    var data: Observable<[UserNotice]> {
        return dataRelay.asObservable()
    }
    var emptyIsHidden: Observable<Bool> {
        return emptyIsHiddenRelay.asObservable()
    }
    var closeSelectView: Observable<Bool> {
        return closeSelectViewSubject.asObservable()
    }
    
    //MARK: - private
    private let disposeBag = DisposeBag()
    private var dataRelay = BehaviorRelay<[UserNotice]>(value: [])
    private var emptyIsHiddenRelay = BehaviorRelay<Bool>(value: true)
    private var closeSelectViewSubject = PublishSubject<Bool>()
    
    
    init() {
        closeData
            .map({ _ in true })
            .bind(to: closeSelectViewSubject)
            .disposed(by: disposeBag)
        
        fetchAll
            .map({ _ in                
                return UserNoticeManager.shared.fetch() ?? []
            })
            .bind(to: dataRelay)
            .disposed(by: disposeBag)
        
        data
            .map({ $0.count != 0 })
            .bind(to: emptyIsHiddenRelay)
            .disposed(by: disposeBag)
        
        selectData
            .filter({ $0 != nil })
            .map({ _ in false })
            .bind(to: closeSelectViewSubject)
            .disposed(by: disposeBag)
        
        deleteData
            .map { (userNotice) -> Void in
                guard let id = userNotice.id,
                      let deleteData = UserNoticeManager.shared.fetch(id: id)?.first else {
                    return
                }
                UserNoticeManager.shared.delete(deleteData)
                UserNotificationManager().removeUserNotification(id: [id])
            }
            .bind(to: fetchAll)
            .disposed(by: disposeBag)
        
        sendAction
            .subscribe { [unowned self](time) in
                guard let data = selectData.value else { return }
                let id = data.id ?? ""
                guard let searchData = UserNoticeManager.shared.fetch(id: id)?.first else {
                    return
                }
                UserNoticeManager.shared.edit(data: searchData, date: time.element ?? "", isOpen: true)
                UserNotificationManager().add(title: data.title ?? "", subTitle: time.element ?? "", image: data.image ?? "", id: id)
                self.fetchAll.onNext(())
                self.closeSelectViewSubject.onNext(true)
            }
            .disposed(by: disposeBag)
    }
}
