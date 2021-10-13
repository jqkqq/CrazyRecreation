//
//  HomeCoordinator.swift
//  CrazyRecreaction

import UIKit

class HomeCoordinator: Coordinator {
    
    var presenter: UIViewController
    var data: Recreation
    
    init(presenter: UIViewController, data: Recreation) {
        self.presenter = presenter
        self.data = data
    }
    
    func start() {
        let vc = HomeDetailViewController()        
        vc.navigationController?.pushViewController(vc, animated: true)
    }
}
