//
//  LabelView.swift
//
//
//  Created by Ilnur Mugaev on 16.04.2024.
//

import UIKit
import SnapKit

public class Label: UIView {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var size: Size
        
        public struct Size: Equatable {
            public var inset: UIEdgeInsets
            public var lineHeight: CGFloat
            
            public init(
                inset: UIEdgeInsets = .zero,
                lineHeight: CGFloat = .zero
            ) {
                self.inset = inset
                self.lineHeight = lineHeight
            }
        }
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            size: Size = .init()
        ) {
            self.text = text
            self.size = size
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        updateLabel(with: viewProperties.text)
        updateSize(with: viewProperties.size)
        
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func updateLabel(with text: NSMutableAttributedString?) {
        textLabel.attributedText = text
        textLabel.isHidden = text == nil
    }
    
    private func updateSize(with size: ViewProperties.Size) {
        guard self.viewProperties.size != size else { return }
        
        textLabel.snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(size.lineHeight)
            $0.edges.equalToSuperview().inset(size.inset)
        }
    }
    
    private func setupView() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0) // будет обновлено
            $0.edges.equalToSuperview().inset(0) // будет обновлено
        }
    }
}
