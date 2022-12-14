//
//  UIViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 08/09/2022.
//

import UIKit

var aView: UIView?

extension UIViewController {
    
    func showSpinner() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.systemBackground
        
        let ai = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        ai.center = aView!.center
        ai.color = UIColor.label
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
