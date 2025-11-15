//
//  Extension+UIView.swift
//  
//
//  Created by firdavs on 01.06.2023.
//

import UIKit

public extension UIView {
    
   func cornerRadius(radius: CGFloat, direction: CornerRadius, clipsToBounds: Bool){
      self.layer.cornerRadius  = radius
      self.clipsToBounds       = clipsToBounds
      self.layer.maskedCorners = direction.radius()
   }
   
    enum CornerRadius {
        
        case topLeft
        case top
        case bottom
        case topRight
        case bottomLeft
        case bottomRight
        case allCorners
        
        public func radius() -> CACornerMask {
            
            switch self {
                    
                case .topLeft:
                    return  [.layerMinXMinYCorner]
                case .topRight:
                    return  [.layerMinXMaxYCorner]
                case .bottomLeft:
                    return  [.layerMaxXMinYCorner]
                case .bottomRight:
                    return  [.layerMaxXMaxYCorner]
                case .top:
                    return  [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                case .bottom:
                    return  [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                case .allCorners:
                    return  [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
}

public extension UIView {
    
    /// Возвращает родительский UIViewController у UIView, если он есть
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
