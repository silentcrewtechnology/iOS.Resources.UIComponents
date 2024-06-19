//
//  BadgeView.swift
//  ABOL
//
//  Created by firdavs on 16.08.2023.
//  Copyright © 2023 ps. All rights reserved.
//

import UIKit
import SnapKit

public final class BadgeView: UIView {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var text: NSAttributedString?
        public var backgroundColor: UIColor?
        public var textColor: UIColor?
        public var image: UIImage?
        public var height: CGFloat
        public var cornerRadius: CGFloat
        public var margins: Margins
        
        public struct Margins {
            public var leading: CGFloat
            public var trailing: CGFloat
            public var top: CGFloat
            public var bottom: CGFloat
            public var spacing: CGFloat
            
            public init(
                leading: CGFloat = 0,
                trailing: CGFloat = 0,
                top: CGFloat = 0,
                bottom: CGFloat = 0,
                spacing: CGFloat = 0
            ) {
                self.leading = leading
                self.trailing = trailing
                self.top = top
                self.bottom = bottom
                self.spacing = spacing
            }
        }
        
        public init(
            text: NSAttributedString? = nil,
            backgroundColor: UIColor? = nil,
            textColor: UIColor? = nil,
            image: UIImage? = nil,
            height: CGFloat = 0,
            cornerRadius: CGFloat = 0,
            margins: Margins = .init()
        ) {
            self.text = text
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.image = image
            self.height = height
            self.cornerRadius = cornerRadius
            self.margins = margins
        }
    }
    
    private var isTextNil: Bool = false
    private var isImageNil: Bool = false

    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let imageView: UIImageView = {
        let label = UIImageView()
        return label
    }()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - public methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        setText(with: viewProperties)
        setBackgroundColor(with: viewProperties)
        setImage(with: viewProperties)
        setCornerRadius(with: viewProperties)
        emptyParamsDetection()
        updateConstraints(with: viewProperties)
    }
    
    // MARK: - private methods
    
    private func emptyParamsDetection() {
        isTextNil = viewProperties.text == nil
        isImageNil = viewProperties.image == nil

    }
    
    private func setText(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.text
        titleLabel.textAlignment = .center
        titleLabel.textColor = viewProperties.textColor
    }
    
    private func setBackgroundColor(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
    }
    
    private func setImage(with viewProperties: ViewProperties) {
        imageView.image = viewProperties.image
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    private func updateConstraints(with viewProperties: ViewProperties) {
        imageView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
        }
        
        let spacing = isTextNil || isImageNil ? 0 : viewProperties.margins.spacing
        
        titleLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.leading.equalTo(imageView.snp.trailing).offset(spacing)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
        }
        
        snp.updateConstraints {
            $0.height.equalTo(viewProperties.height)
        }
    }
    
    private func setupView() {
        addSubview(imageView)
        imageView.snp.makeConstraints() {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalTo(imageView.snp.trailing).offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(0)
        }
    }
}
