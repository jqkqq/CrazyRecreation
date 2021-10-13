//
//  UserNoticeManager.swift
//  CrazyRecreaction


import Foundation
import CoreData
import UserNotifications

class UserNoticeManager {
    
    static let shared = UserNoticeManager()
    
    func add(_ data: UNNotificationRequest, image: String, time: String) {
        if let entity = NSEntityDescription.entity(forEntityName: "UserNotice", in: CoreDataManager.shared.persistentContainer.viewContext) {
            let userNotice = UserNotice(entity: entity, insertInto: CoreDataManager.shared.persistentContainer.viewContext)
            userNotice.id = data.identifier
            userNotice.date = time
            userNotice.title = data.content.title
            userNotice.image = image
            userNotice.isOpen = true
            CoreDataManager.shared.saveContext()
        }
    }
    
    func delete(_ data: UserNotice) {
        CoreDataManager.shared.persistentContainer.viewContext.delete(data)
        CoreDataManager.shared.saveContext()
    }
    
    func fetch(id: String? = nil) -> [UserNotice]? {
        let request: NSFetchRequest<UserNotice> = UserNotice.fetchRequest()
        if id != nil {
            request.predicate = NSPredicate(format: "id = %@", "\(id ?? "")")
        }
        do {
            let results = try CoreDataManager.shared.persistentContainer.viewContext.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func edit(data: UserNotice, date: String, isOpen: Bool) {
        data.date = date
        data.isOpen = isOpen
        CoreDataManager.shared.saveContext()
    }
    
}
