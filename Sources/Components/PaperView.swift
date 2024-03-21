//
//  PaperView.swift
//
//
//  Created by Ilnur Mugaev on 03.12.2023.
//

import UIKit
import SnapKit

public final class PaperView: UIView {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        var cornerRadius: CGFloat
        var maskedCorners: CACornerMask
        var masksToBounds: Bool
        var backgroundColor: UIColor
        var shadow: Shadow
        
        public init(
            cornerRadius: CGFloat = 0,
            maskedCorners: CACornerMask = [],
            masksToBounds: Bool = true,
            backgroundColor: UIColor = .clear,
            shadow: Shadow = .init()
        ) {
            self.cornerRadius = cornerRadius
            self.maskedCorners = maskedCorners
            self.masksToBounds = masksToBounds
            self.backgroundColor = backgroundColor
            self.shadow = shadow
        }
        
        public struct Shadow {
            var color: UIColor
            var offset: CGSize
            var opacity: Float
            var radius: CGFloat
            
            public init(
                color: UIColor = .clear,
                offset: CGSize = .zero,
                opacity: Float = 0,
                radius: CGFloat = 0
            ) {
                self.color = color
                self.offset = offset
                self.opacity = opacity
                self.radius = radius
            }
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        updateView(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func updateView(with viewProperties: ViewProperties) {
        
        backgroundColor = viewProperties.backgroundColor
        
        layer.cornerRadius = viewProperties.cornerRadius
        layer.maskedCorners = viewProperties.maskedCorners
        layer.masksToBounds = viewProperties.masksToBounds
        
        layer.shadowColor = viewProperties.shadow.color.cgColor
        layer.shadowOffset = viewProperties.shadow.offset
        layer.shadowOpacity = viewProperties.shadow.opacity
        layer.shadowRadius = viewProperties.shadow.radius
    }
}
