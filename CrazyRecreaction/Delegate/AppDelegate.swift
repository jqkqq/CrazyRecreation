//
//  AppDelegate.swift
//  CrazyRecreaction


import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert,.sound,.badge, .carPlay], completionHandler: { (granted, error) in
            if granted {
                print("允許")
            } else {
                print("不允許")
            }
        })
        UNUserNotificationCenter.current().delegate = self
        
        let appearance = UINavigationBarAppearance()
        let tabAppearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        } else {
            // Fallback on earlier versions
        }
        
        let homeNav = UINavigationController()
        homeNav.viewControllers = [HomeViewController()]
        homeNav.tabBarItem = UITabBarItem(title: "旅游景点", image: UIImage(named: "icons8-beach-umbrella-32"), selectedImage: UIImage(named: "icons8-beach-umbrella-32"))
        homeNav.navigationBar.standardAppearance = appearance
        homeNav.navigationBar.scrollEdgeAppearance = homeNav.navigationBar.standardAppearance
        
        let loveNav = UINavigationController()
        loveNav.viewControllers = [LoveDataViewController()]
        loveNav.tabBarItem = UITabBarItem(title: "我的最爱", image: UIImage(named: "icons8-love-32"), selectedImage: UIImage(named: "icons8-love-32"))
        loveNav.navigationBar.standardAppearance = appearance
        loveNav.navigationBar.scrollEdgeAppearance = loveNav.navigationBar.standardAppearance
        
        let noticeNav = UINavigationController()
        noticeNav.viewControllers = [NoticeViewController()]
        noticeNav.tabBarItem = UITabBarItem(title: "提醒", image: UIImage(named: "icons8-clock-32"), selectedImage: UIImage(named: "icons8-clock-32"))
        noticeNav.navigationBar.standardAppearance = appearance
        noticeNav.navigationBar.scrollEdgeAppearance = noticeNav.navigationBar.standardAppearance
        
        tabBarController.viewControllers = [homeNav, loveNav, noticeNav]
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
    }
}
