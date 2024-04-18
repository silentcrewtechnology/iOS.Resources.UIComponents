//
//  PayCell.swift
//
//
//  Created by firdavs on 16.04.2024.
//

import SnapKit
import UIKit

public final class PayCell: UITableViewCell {
   
    public struct ViewProperties {
        public var title: NSMutableAttributedString?
        public var subtitle: NSMutableAttributedString?
        public var rightInfo: NSMutableAttributedString?
        public var iconImage: UIImage?
        public var backgroundColor: UIColor?
        public var cornerRadius: CGFloat = 12
        public var action: (() -> Void)?
        
        public init(
            title: NSMutableAttributedString? = nil,
            subtitle: NSMutableAttributedString? = nil,
            rightInfo: NSMutableAttributedString? = nil,
            iconImage: UIImage? = nil,
            backgroundColor: UIColor? = nil,
            cornerRadius: CGFloat = 12,
            action: (() -> Void)? = nil
        ) {
            self.title = title
            self.rightInfo = rightInfo
            self.subtitle = subtitle
            self.iconImage = iconImage
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.action = action
        }
    }
    
    // MARK: - UI
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let rightInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: - private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Init
    
    public override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addedViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - public methods
    
    public func update(with viewProperties: ViewProperties) {
        setData(with: viewProperties)
        cornerRadius(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - private methods
    
    private func setData(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.title
        subtitleLabel.attributedText = viewProperties.subtitle
        rightInfoLabel.attributedText = viewProperties.rightInfo
        iconImageView.image = viewProperties.iconImage
        backgroundColor = viewProperties.backgroundColor
    }
    
    private func addedViews() {
        addSubview(iconImageView)
        addSubview(titlesStackView)
        addSubview(rightInfoLabel)
        titlesStackView.addArrangedSubview(titleLabel)
        titlesStackView.addArrangedSubview(subtitleLabel)
    }
    
    private func cornerRadius(with viewProperties: ViewProperties) {
        self.cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func setupConstraints() {
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(26)
        }
        
        rightInfoLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(8)
        }
        
        titlesStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.trailing.equalTo(rightInfoLabel.snp.leading).inset(8)
            $0.leading.equalTo(iconImageView.snp.trailing).inset(-14)
            $0.bottom.equalToSuperview().inset(14)
        }
    }
}
