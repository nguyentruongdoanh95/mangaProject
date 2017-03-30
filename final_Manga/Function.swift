//
//  Function.swift
//  final_Manga
//
//  Created by Godfather on 12/10/16.
//  Copyright © 2016 Godfather. All rights reserved.
//

import UIKit




func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
}

extension UIView {
    func addConstraintWithVSF(format: String, views: UIView...) {
        var dict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            dict[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: dict))
    }
}


