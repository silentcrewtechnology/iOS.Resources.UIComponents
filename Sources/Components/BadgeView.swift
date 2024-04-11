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
        
        public init(
            text: NSAttributedString? = nil,
            backgroundColor: UIColor? = nil,
            textColor: UIColor? = nil,
            image: UIImage? = nil,
            height: CGFloat = 0,
            cornerRadius: CGFloat = 0
        ) {
            self.text = text
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.image = image
            self.height = height
            self.cornerRadius = cornerRadius
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private var titleVerticalConstraints: Constraint?
    private var titleLeadingConstraints: Constraint?
    private var titleTrailingConstraints: Constraint?
    private var imageEdgesConstraints: Constraint?
    
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
        setHidden(with: viewProperties)
        setText(with: viewProperties)
        setBackgroundColor(with: viewProperties)
        setImage(with: viewProperties)
        setCornerRadius(with: viewProperties)
        updateConstraints(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - private methods
    
    private func setHidden(with viewProperties: ViewProperties) {
        if viewProperties.text == nil && viewProperties.image == nil {
            isHidden = true
            return
        }
        isHidden = false
        
        imageView.isHidden = isItText(with: viewProperties) ? true : false
        titleLabel.isHidden = isItText(with: viewProperties) ? false : true
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
        snp.updateConstraints {
            $0.height.equalTo(viewProperties.height)
        }
        
        let isItText = isItText(with: viewProperties)
        isActiveConstraints(isItText: isItText)
        
        if !isItText {
            imageView.snp.updateConstraints {
                $0.height.width.equalTo(viewProperties.height)
            }
        }
    }
    
    private func isItText(with viewProperties: ViewProperties) -> Bool {
        return !(viewProperties.image != nil && viewProperties.text == nil)
    }
    
    private func isActiveConstraints(isItText: Bool) {
        titleVerticalConstraints?.isActive = isItText
        titleLeadingConstraints?.isActive = isItText
        titleTrailingConstraints?.isActive = isItText
        imageEdgesConstraints?.isActive = !isItText
    }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            titleVerticalConstraints = $0.top.bottom.equalToSuperview().constraint
            titleLeadingConstraints = $0.leading.equalToSuperview().offset(Constants.labelPadding).constraint
            titleTrailingConstraints = $0.trailing.equalToSuperview().offset(-Constants.labelPadding).constraint
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints() {
            imageEdgesConstraints = $0.edges.equalToSuperview().constraint
            $0.height.width.equalTo(0) // будет обновлено
        }
        
        snp.makeConstraints {
            $0.height.equalTo(0) // будет обновлено
        }
    }
}

private struct Constants {
    static let imagePadding = 2
    static let labelPadding = 6
}
