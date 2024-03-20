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
        
        public init(
            text: NSAttributedString? = nil,
            backgroundColor: UIColor? = nil
        ) {
            self.text = text
            self.backgroundColor = backgroundColor
        }
    }
    
    // MARK: - UI
    
    private var mainView: UIView = {
        let view = UIView()
        view.cornerRadius(
            radius: 10,
            direction: .allCorners,
            clipsToBounds: true
        )
        view.isHidden = true
        return view
    }()
    
    private lazy var titleLabel = UILabel()
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addedViews()
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - public methods
    
    public func update(with viewProperties: ViewProperties) {
        setText(with: viewProperties)
        setColor(with: viewProperties)
        updateConstraints(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - private methods
    
    private func setText(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.text
        titleLabel.textAlignment = .center
    }
    
    private func setColor(with viewProperties: ViewProperties) {
        mainView.backgroundColor = viewProperties.backgroundColor
    }
    
    private func setConstraints() {
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(Constants.labelHeight)
            $0.width.equalTo(Constants.labelHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Constants.labelPadding)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        guard let text = viewProperties.text else {
            mainView.isHidden = true
            return
        }
        mainView.isHidden = false
        let width = text.width(
            height: CGFloat(Constants.labelHeight),
            add: CGFloat(Constants.labelPadding * 2)
        )
        mainView.snp.updateConstraints {
            $0.width.equalTo(width)
        }
    }
    
    private func addedViews() {
        self.addSubview(mainView)
        mainView.addSubview(titleLabel)
    }
}

private struct Constants {
    
    static let labelPadding = 6
    static let labelHeight = 20
}
