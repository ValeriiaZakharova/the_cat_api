//
//  UIViewController+spinner.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 26.03.2022.
//

import UIKit

var spinner : UIView?

extension UIViewController {

    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor =  .clear
        let activityIndicator = UIActivityIndicatorView.init(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }

        spinner = spinnerView
    }

    func removeSpinner() {
        DispatchQueue.main.async {
            spinner?.removeFromSuperview()
            spinner = nil
        }
    }
}
