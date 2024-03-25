//
//  IndicatorView.swift
//  
//
//  Created by user on 25.03.2024.
//

import UIKit
import SnapKit

public final class IndicatorView: UIView {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor?
        public var size: CGFloat
        
        public init(
            backgroundColor: UIColor? = nil,
            size: CGFloat = .zero
        ) {
            self.backgroundColor = backgroundColor
            self.size = size
        }
    }
    
    // MARK: - UI
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - public methods
    
    public func update(with viewProperties: ViewProperties) {
        if self.viewProperties.size != viewProperties.size {
            snp.updateConstraints {
                $0.size.equalTo(viewProperties.size)
            }
        }
        backgroundColor = viewProperties.backgroundColor
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }

    
    // MARK: - private methods
    
    private func setupView() {
        snp.makeConstraints {
            $0.size.equalTo(0) // будет обновляться
        }
    }
}
