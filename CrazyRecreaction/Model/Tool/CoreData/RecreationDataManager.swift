//
//  RecreationDataManager.swift
//  CrazyRecreaction

import Foundation
import CoreData

class RecreationDataManager {
    
    static let shared = RecreationDataManager()
    
    func add(_ data: Datum) {
        if let entity = NSEntityDescription.entity(forEntityName: "RecreationData", in: CoreDataManager.shared.persistentContainer.viewContext) {
            let recreationData = RecreationData(entity: entity, insertInto: CoreDataManager.shared.persistentContainer.viewContext)
            recreationData.name = data.name
            recreationData.address = data.address
            recreationData.zipcode = data.zipcode
            recreationData.introduction = data.introduction
            recreationData.url = data.url
            recreationData.openTime = data.openTime
            var images: [String] = []
            data.images?.forEach({
                images.append($0.src ?? "")
            })
            recreationData.images = images
            CoreDataManager.shared.saveContext()
        }
    }
    
    func delete(_ data: RecreationData) {
        CoreDataManager.shared.persistentContainer.viewContext.delete(data)
        CoreDataManager.shared.saveContext()
    }
    
    func fetch() -> [RecreationData]? {
        let request: NSFetchRequest<RecreationData> = RecreationData.fetchRequest()
        do {
            let results = try CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
