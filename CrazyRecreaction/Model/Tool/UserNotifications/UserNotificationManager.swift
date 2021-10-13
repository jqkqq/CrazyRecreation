//
//  UserNotice.swift
//  CrazyRecreaction

import Foundation
import UserNotifications

class UserNotificationManager {
    
    func add(title: String, subTitle: String, image: String, id: String? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = "您的\(title)即將在\(subTitle)的時間開始"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_tw")
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        if let myDate = dateFormatter.date(from: subTitle) {
            print(myDate)
            let components = Calendar.current.dateComponents([.month, .day, .year], from: myDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let newId = id == nil ? UUID().uuidString: (id ?? "")
            let request = UNNotificationRequest(identifier: newId, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                id == nil ?
                    UserNoticeManager.shared.add(request, image: image, time: subTitle): nil
                print("成功通知")
            }
        }
        
    }
        
    func removeUserNotification(id: [String]) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: id)
        print("\(id)，成功刪除")
    }
    
    func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
