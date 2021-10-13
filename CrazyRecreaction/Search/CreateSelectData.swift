//
//  CreateSelectData.swift
//  CrazyRecreaction


import Foundation
import RxSwift
import RxCocoa

struct SelectData {
    var id: Int
    var name: String
    var select = false
}

class CreateSelectData {
    
    func getData() -> Single<[SelectData]> {
        return Single<[SelectData]>.create { (single) -> Disposable in
            let data: [SelectData] = [SelectData(id: 11, name: "养生温泉"),
                                      SelectData(id: 12, name: "单车游踪"),
                                      SelectData(id: 13, name: "历史建筑"),
                                      SelectData(id: 14, name: "宗教信仰"),
                                      SelectData(id: 15, name: "艺文馆所"),
                                      SelectData(id: 16, name: "户外踏青"),
                                      SelectData(id: 17, name: "蓝色水路"),
                                      SelectData(id: 18, name: "公共艺术"),
                                      SelectData(id: 19, name: "亲子共游"),
                                      SelectData(id: 20, name: "北北基景点"),
                                      SelectData(id: 23, name: "夜市商圈"),
                                      SelectData(id: 24, name: "主题商街"),
                                      SelectData(id: 25, name: "无障碍旅游推荐景点"),
                                      SelectData(id: 499, name: "其他")]
            single(.success(data))
            return Disposables.create()
        }
    }
}
