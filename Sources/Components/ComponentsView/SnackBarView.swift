//
//  SnackBarView.swift
//
//
//  Created by Ilnur Mugaev on 26.03.2024.
//

import UIKit
import SnapKit

public class SnackBarView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString?
        public var content: NSMutableAttributedString?
        public var icon: UIImage?
        public var closeButton: CloseButton?
        public var bottomButton: BottomButton?
        public var backgroundColor: UIColor
        public var shadow: Shadow?
        public var additionalOffset: CGFloat
        public var animationIn: Animation
        public var animationOut: Animation
        
        public init(
            title: NSMutableAttributedString? = nil,
            content: NSMutableAttributedString? = nil,
            icon: UIImage? = nil,
            closeButton: CloseButton? = nil,
            bottomButton: BottomButton? = nil,
            backgroundColor: UIColor = .clear,
            shadow: Shadow? = nil,
            additionalOffset: CGFloat = 16,
            animationIn: Animation = .init(),
            animationOut: Animation = .init()
        ) {
            self.title = title
            self.content = content
            self.icon = icon
            self.closeButton = closeButton
            self.bottomButton = bottomButton
            self.backgroundColor = backgroundColor
            self.shadow = shadow
            self.additionalOffset = additionalOffset
            self.animationIn = animationIn
            self.animationOut = animationOut
        }
        
        public struct CloseButton {
            public var icon: UIImage
            public var action: () -> Void
            
            public init(
                icon: UIImage = .init(),
                action: @escaping () -> Void = { }
            ) {
                self.icon = icon
                self.action = action
            }
        }
        
        public struct BottomButton {
            public var title: NSMutableAttributedString
            public var action: () -> Void
            
            public init(
                title: NSMutableAttributedString = .init(string: ""),
                action: @escaping () -> Void = { }
            ) {
                self.title = title
                self.action = action
            }
        }
        
        public struct Shadow {
            public var color: CGColor
            public var offset: CGSize
            public var radius: CGFloat
            public var opacity: Float
            
            public init(
                color: CGColor,
                offset: CGSize,
                radius: CGFloat,
                opacity: Float
            ) {
                self.color = color
                self.offset = offset
                self.radius = radius
                self.opacity = opacity
            }
        }
        
        public struct Animation {
            public var duration: TimeInterval
            public var delay: TimeInterval
            public var options: UIView.AnimationOptions
            public var showTime: TimeInterval
            
            public init(
                duration: TimeInterval = .zero,
                delay: TimeInterval = .zero,
                options: UIView.AnimationOptions = [.curveLinear],
                showTime: TimeInterval = .zero
            ) {
                self.duration = duration
                self.delay = delay
                self.options = options
                self.showTime = showTime
            }
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.snp.makeConstraints { $0.size.equalTo(24) }
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var spacerView: SpacerView = {
        let spacer = SpacerView()
        spacer.update(with: .init(size: .init(width: 0, height: 8)))
        return spacer
    }()
    
    private lazy var bottomButton: UIButton = {
        let button = CorrectHeightButton()
        button.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 16, height: 24))
        }
        return button
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            contentLabel,
            spacerView,
            bottomButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            iconView,
            vStack,
            closeButton
        ])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        layer.cornerRadius = 12
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        bringSubviewToFront(closeButton)
    }
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        updateLabel(titleLabel, text: viewProperties.title)
        updateLabel(contentLabel, text: viewProperties.content)
        updateCloseButton(viewProperties.closeButton)
        updateBottomButton(viewProperties.bottomButton)
        updateShadow(viewProperties.shadow)
        iconView.image = viewProperties.icon
        backgroundColor = viewProperties.backgroundColor
        self.viewProperties = viewProperties
    }
    
    public func show(on view: UIView) {
        
        view.addSubview(self)
        self.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.snp.bottom)
        }
        
        layoutIfNeeded()
        
        animateIn(
            viewProperties.animationIn,
            offset: calculateOffset(in: view)
        ) { [weak self] in
            guard let self else { return }
            self.animateOut(self.viewProperties.animationOut)
        }
    }
    
    public func hide() {
        closeButtonTapped()
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
    
    private func updateBottomButton(_ button: ViewProperties.BottomButton?) {
        if let button {
            bottomButton.setAttributedTitle(button.title, for: .normal)
            bottomButton.isHidden = false
            spacerView.isHidden = false
        } else {
            bottomButton.isHidden = true
            spacerView.isHidden = true
        }
    }
    
    private func updateCloseButton(_ button: ViewProperties.CloseButton?) {
        if let button {
            closeButton.setImage(button.icon, for: .normal)
            closeButton.isHidden = false
        } else {
            closeButton.isHidden = true
        }
    }
    
    private func updateShadow(_ shadow: ViewProperties.Shadow?) {
        guard let shadow else { return }
        layer.shadowColor = shadow.color
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = shadow.radius
        layer.shadowOpacity = shadow.opacity
    }
    
    private func calculateOffset(in view: UIView) -> CGFloat {
        var offset = frame.size.height + viewProperties.additionalOffset
        
        if let parentController = view.parentViewController as? UITabBarController,
           !parentController.tabBar.isHidden {
            offset += parentController.tabBar.frame.size.height
        } else if let window = UIApplication.shared.keyWindow {
            offset += window.safeAreaInsets.bottom
        }
        
        return offset
    }
    
    // MARK: - Actions
    
    @objc private func bottomButtonTapped() {
        viewProperties.bottomButton?.action()
    }
    
    @objc private func closeButtonTapped() {
        layer.removeAllAnimations()
        animateOut(viewProperties.animationOut, isInstant: true)
        viewProperties.closeButton?.action()
    }
    
    // MARK: - Animations
    
    private func animateIn(
        _ animation: ViewProperties.Animation,
        offset: CGFloat,
        completion: @escaping () -> Void
    ) {
        UIView.animate(
            withDuration: animation.duration,
            delay: animation.delay,
            options: animation.options,
            animations: {
                self.transform = CGAffineTransform(
                    translationX: 0.0,
                    y: -offset)
            },
            completion: { _ in
                completion()
            }
        )
    }
    
    private func animateOut(
        _ animation: ViewProperties.Animation,
        isInstant: Bool = false
    ) {
        let delay: TimeInterval = isInstant ? 0 : animation.showTime
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(
                withDuration: animation.duration,
                delay: animation.delay,
                options: animation.options,
                animations: {
                    self.transform = .identity
                },
                completion: { _ in
                    self.removeFromSuperview()
                }
            )
        }
    }
}

// MARK: - CorrectHeightButton -

/// Кнопка-лейбл с высотой, равной высоте titleLabel
/// (без лишних отступов по вертикали)
public final class CorrectHeightButton: UIButton {
    public override var intrinsicContentSize: CGSize {
        guard let titleLabel = titleLabel else { return .zero }
        let labelSize = titleLabel.sizeThatFits(
            CGSize(
                width: frame.width,
                height: CGFloat.greatestFiniteMagnitude))
        let desiredButtonSize = CGSize(
            width: labelSize.width,
            height: labelSize.height)
        return desiredButtonSize
    }
}
