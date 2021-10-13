//
//  ImageExtention.swift
//  CrazyRecreaction


import Foundation
import Kingfisher

extension UIImageView {
    func setupIndicatorType() {
        var kf = self.kf
        kf.indicatorType = .activity
    }
}
