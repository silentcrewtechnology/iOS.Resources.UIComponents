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
        var cornerRadius: CGFloat = 0
        var maskedCorners: CACornerMask = []
        var masksToBounds: Bool = true
        var backgroundColor: UIColor = .clear
        var shadow: Shadow = .init()
        
        public struct Shadow {
            var color: UIColor = .clear
            var offset: CGSize = .zero
            var opacity: Float = 0
            var radius: CGFloat = 0
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
