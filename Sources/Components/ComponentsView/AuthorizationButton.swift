//
//  AuthorizationButton.swift
//
//
//  Created by Ilnur Mugaev on 20.03.2024.
//

import UIKit
import SnapKit

public class AuthorizationButton: UIButton, ComponentProtocol {
    
    public struct ViewProperties {
        public var image: UIImage
        public var title: NSMutableAttributedString
        public var backgroundColor: UIColor
        public var highlightedColor: UIColor
        public var spacing: CGFloat
        public var onTap: () -> Void
        
        public init(
            image: UIImage = .init(),
            title: NSMutableAttributedString = .init(string: ""),
            backgroundColor: UIColor = .clear,
            highlightedColor: UIColor = .clear,
            spacing: CGFloat = .zero,
            onTap: @escaping () -> Void = { }
        ) {
            self.image = image
            self.title = title
            self.backgroundColor = backgroundColor
            self.highlightedColor = highlightedColor
            self.spacing = spacing
            self.onTap = onTap
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted
            ? viewProperties.highlightedColor
            : viewProperties.backgroundColor
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateImage(image: viewProperties.image)
        updateTitle(title: viewProperties.title)
        updateInsets(spacing: viewProperties.spacing)
        backgroundColor = viewProperties.backgroundColor
        self.viewProperties = viewProperties
    }
    
    private func updateImage(image: UIImage) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
    }
    
    private func updateTitle(title: NSMutableAttributedString) {
        setAttributedTitle(title, for: .normal)
        setAttributedTitle(title, for: .highlighted)
    }
    
    private func updateInsets(spacing: CGFloat) {
        let halfSpacing = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -halfSpacing, bottom: 0, right: halfSpacing)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: halfSpacing, bottom: 0, right: -halfSpacing)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: halfSpacing, bottom: 0, right: halfSpacing)
    }
    
    @objc private func buttonTapped() {
        viewProperties.onTap()
    }
}
