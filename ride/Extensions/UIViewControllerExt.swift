//
//  UIViewControllerExt.swift
//  ride
//
//  Created by Darren Fuller.
//  Copyright © 2020 Darren Fuller. All rights reserved.
//

import UIKit

extension UIViewController {
    func shouldPresentLoadingView(_ status: Bool) {
        var fadeView: UIView?
        
        if status == true {
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            fadeView?.backgroundColor = UIColor.black
            fadeView?.alpha = 0.0
            
            fadeView?.tag = 99
            
            let spinner = UIActivityIndicatorView()
            spinner.color = UIColor.white
            if #available(iOS 13.0, *) {
                spinner.style = .large
            } else {
                spinner.style = .whiteLarge
            }
            spinner.center = view.center
            
            view.addSubview(fadeView!)
            fadeView?.addSubview(spinner)
            
            spinner.startAnimating()
            
            fadeView?.fadeTo(alphaValue: 0.7, withDuration: 0.2)
            
        } else {
            for subview in view.subviews {
                if subview.tag == 99 {

                    UIView.animate(withDuration: 0.2, animations: {
                        subview.alpha = 0.0
                    }, completion: { (finished) in
                        subview.removeFromSuperview()
                    })
                }
            }
        }
        
    }
}
