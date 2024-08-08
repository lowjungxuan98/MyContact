//
//  Ext+UIView.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit

extension UIView {
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(
            rect: CGRect(
                x: 0,
                y: bounds.maxY - layer.shadowRadius,
                width: bounds.width,
                height: layer.shadowRadius
            )
        ).cgPath
    }
}
