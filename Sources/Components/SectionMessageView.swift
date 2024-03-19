//
//  SectionMessageView.swift
//  
//
//  Created by firdavs on 09.06.2023.
//

import UIKit
import SnapKit

public final class SectionMessageView: UIView {
    
    public struct ViewProperties {
        public var title: NSAttributedString?
        public var content: NSAttributedString?
        public var subtitle: NSAttributedString?
        public var iconImage: UIImage?
        public var backgroundColor: UIColor?
        public var action: (() -> Void)?
        
        public init(
            title: NSAttributedString? = nil,
            content: NSAttributedString? = nil,
            subtitle: NSAttributedString? = nil,
            iconImage: UIImage? = nil,
            backgroundColor: UIColor? = nil,
            action: (() -> Void)? = nil
        ) {
            self.title = title
            self.content = content
            self.subtitle = subtitle
            self.iconImage = iconImage
            self.backgroundColor = backgroundColor
            self.action = action
        }
    }
    
    //MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    //MARK: - private properties
    
    private var viewProperties: ViewProperties = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addedViews()
        setupConstraints()
        setupActionButton()
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - public methods
    
    public func update(with viewProperties: ViewProperties) {
        setData(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    //MARK: - private methods
    
    private func setData(with viewProperties: ViewProperties){
        titleLabel.attributedText = viewProperties.title
        contentLabel.attributedText = viewProperties.content
        subtitleLabel.attributedText = viewProperties.subtitle
        actionButton.setImage(viewProperties.iconImage, for: .normal)
        backgroundColor = viewProperties.backgroundColor
    }
    
    private func setupView(){
        self.cornerRadius(
            radius: 12,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func setupActionButton(){
        let action = #selector(didTapAction)
        actionButton.addTarget(self, action: action, for: .touchUpInside)
    }
    
    private func addedViews(){
        addSubview(actionButton)
        addSubview(titlesStackView)
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(contentLabel)
        titlesStackView.addArrangedSubview(subtitleLabel)
    }
    
    private func setupConstraints(){
    
        actionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.left.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
        
        titlesStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalTo(actionButton.snp.trailing).inset(-14)
            $0.bottom.equalToSuperview().offset(-14)
        }
    }
    
    @objc
    private func didTapAction(){
        viewProperties.action?()
    }
}

