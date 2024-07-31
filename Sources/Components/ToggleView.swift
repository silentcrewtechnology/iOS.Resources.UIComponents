//
//  ToggleView.swift
//
//
//  Created by user on 13.05.2024.
//

import UIKit

public final class ToggleView: UIView {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var isEnabled: Bool
        public var isChecked: Bool
        public var offTintColor: UIColor?
        public var onTintColor: UIColor?
        public var thumbOffTintColor: UIColor?
        public var thumbOnTintColor: UIColor?
        public var checkAction: (Bool) -> Void
        
        public init(
            isEnabled: Bool = true,
            isChecked: Bool = false,
            offTintColor: UIColor? = nil,
            onTintColor: UIColor? = nil,
            thumbOffTintColor: UIColor? = nil,
            thumbOnTintColor: UIColor? = nil,
            checkAction: @escaping (Bool) -> Void = { _ in }
        ) {
            self.isEnabled = isEnabled
            self.isChecked = isChecked
            self.offTintColor = offTintColor
            self.onTintColor = onTintColor
            self.thumbOffTintColor = thumbOffTintColor
            self.thumbOnTintColor = thumbOnTintColor
            self.checkAction = checkAction
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    private lazy var switchView = UISwitch()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setupProperties(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(switchView)
        switchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupProperties(with viewProperties: ViewProperties) {
        switchView.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        switchView.isOn = viewProperties.isChecked
        switchView.isEnabled = viewProperties.isEnabled
        
        if let onTintColor = viewProperties.onTintColor {
            switchView.onTintColor = onTintColor
        }
        
        if let offTintColor = viewProperties.offTintColor {
            switchView.tintColor = offTintColor
            switchView.subviews[0].subviews[0].backgroundColor = offTintColor
        }
        
        setupThumbColor(isOn: viewProperties.isChecked)
    }
    
    private func setupThumbColor(isOn: Bool) {
        switchView.thumbTintColor = isOn
            ? viewProperties.onTintColor
            : viewProperties.thumbOffTintColor
    }
    
    @objc private func switchTapped(_ sender: UISwitch) {
        viewProperties.checkAction(sender.isOn)
        setupThumbColor(isOn: sender.isOn)
    }
}
