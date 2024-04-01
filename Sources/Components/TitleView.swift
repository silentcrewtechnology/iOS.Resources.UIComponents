//
//  TitleView.swift
//
//
//  Created by Ilnur Mugaev on 01.04.2024.
//

import UIKit
import SnapKit

public class TitleView: UIView {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString
        public var description: NSMutableAttributedString?
        public var iconButtonViewProperties: IconButton.ViewProperties?
        public var backgroundColor: UIColor
        public var insets: UIEdgeInsets
        public var space: CGFloat
        
        public init(
            title: NSMutableAttributedString = .init(string: ""),
            description: NSMutableAttributedString? = nil,
            iconButtonViewProperties: IconButton.ViewProperties? = nil,
            backgroundColor: UIColor = .clear,
            insets: UIEdgeInsets = .zero,
            space: CGFloat = .zero
        ) {
            self.title = title
            self.description = description
            self.iconButtonViewProperties = iconButtonViewProperties
            self.backgroundColor = backgroundColor
            self.insets = insets
            self.space = space
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var iconButton: IconButton = {
        let button = IconButton()
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            iconButton
        ])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            hStack,
            descriptionLabel
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public method
    
    public func update(with viewProperties: ViewProperties) {
        updateLabel(titleLabel, text: viewProperties.title)
        updateLabel(descriptionLabel, text: viewProperties.description)
        updateIconButton(viewProperties.iconButtonViewProperties)
        updateAlignment()
        updateInsets(viewProperties.insets)
        vStack.spacing = viewProperties.space
        backgroundColor = viewProperties.backgroundColor
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func updateLabel(_ label: UILabel, text: NSAttributedString?) {
        if let text {
            label.attributedText = text
            label.isHidden = false
        } else {
            label.isHidden = true
        }
    }
    
    private func updateIconButton(_ iconButtonViewProperties: IconButton.ViewProperties?) {
        if let iconButtonViewProperties {
            iconButton.update(with: iconButtonViewProperties)
            iconButton.isHidden = false
        } else {
            iconButton.isHidden = true
        }
    }
    
    private func updateAlignment() {
        guard !iconButton.isHidden else { return }
        hStack.alignment = descriptionLabel.isHidden ? .center : .top
    }
    
    private func updateInsets(_ insets: UIEdgeInsets) {
        vStack.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(insets)
        }
    }
}
