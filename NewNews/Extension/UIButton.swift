//
//  UIButton.swift
//  NewNews
//
//  Created by valters.steinblums on 08/09/2022.
//

import UIKit

extension UIButton {
    func roundSelectCorners(corners: UIRectCorner, radius: Int) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
