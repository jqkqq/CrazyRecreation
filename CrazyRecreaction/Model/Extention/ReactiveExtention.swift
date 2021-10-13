//
//  ReactiveExtention.swift
//  CrazyRecreaction

import Foundation
import RxSwift
import RxCocoa
import NVActivityIndicatorView

extension Reactive where Base: NVActivityIndicatorView {

    public var isAnimating: Binder<Bool> {
        return Binder(self.base) { activityIndicator, active in
            if active {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

}
