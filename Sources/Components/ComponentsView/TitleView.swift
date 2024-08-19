//
//  TitleView.swift
//
//
//  Created by Ilnur Mugaev on 01.04.2024.
//

import UIKit
import SnapKit

public class TitleView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString
        public var backgroundColor: UIColor
        public var insets: UIEdgeInsets
        
        public init(
            title: NSMutableAttributedString = .init(string: ""),
            backgroundColor: UIColor = .clear,
            insets: UIEdgeInsets = .zero
        ) {
            self.title = title
            self.backgroundColor = backgroundColor
            self.insets = insets
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public method
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        backgroundColor = viewProperties.backgroundColor
        updateLabel(text: viewProperties.title)
        updateInsets(viewProperties.insets)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateLabel(text: NSAttributedString?) {
        titleLabel.isHidden = text != nil ? false : true
        titleLabel.attributedText = text
    }
    
    private func updateInsets(_ insets: UIEdgeInsets) {
        titleLabel.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(insets)
        }
    }
}
