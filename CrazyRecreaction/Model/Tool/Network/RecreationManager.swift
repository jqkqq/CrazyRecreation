//
//  RecreationManager.swift
//  CrazyRecreaction


import Foundation
import RxSwift
import Alamofire

class RecreationManager {
    
    func loadData(page: Int, id: String? = nil, completion: @escaping(Result<Recreation, Error>) -> Void) {
        let url = "https://www.travel.taipei/open-api/zh-cn/Attractions/All"
        let header: HTTPHeaders = ["accept": "application/json"]
        let parameters: [String : Any] =
            ["page": page,
             "categoryIds": id ?? "" ]
        print(parameters)
        AF.request(url, method: .get, parameters: parameters, headers: header).responseJSON { (response) in
            print(response.request?.url ?? "")
            switch response.result {
            case .success(_):
                if let data = response.data {
                    do {
                        let recreation = try JSONDecoder().decode(Recreation.self, from: data)
                        completion(.success(recreation))
                    } catch {
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
