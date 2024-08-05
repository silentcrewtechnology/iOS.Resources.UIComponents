//
//  SnackBarView.swift
//
//
//  Created by Ilnur Mugaev on 26.03.2024.
//

import UIKit
import SnapKit

public class SnackBarView: UIView {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString?
        public var subtitle: NSMutableAttributedString?
        public var icon: Icon
        public var closeButton: CloseButton?
        public var bottomButton: BottomButton?
        public var backgroundColor: UIColor
        public var shadow: Shadow?
        public var cornerRadius: CGFloat
        public var additionalOffset: CGFloat
        public var verticalStackSpacing: CGFloat
        public var horizontalStackViewSpacing: CGFloat
        public var height: Int
        public var animationIn: Animation
        public var animationOut: Animation
        public var spacerViewProperties: SpacerView.ViewProperties?
        public var containerViewInsets: UIEdgeInsets
        public var stackViewInsets: UIEdgeInsets
        public var animationInsets: UIEdgeInsets
        
        public init(
            title: NSMutableAttributedString? = nil,
            subtitle: NSMutableAttributedString? = nil,
            icon: Icon = .init(),
            closeButton: CloseButton? = nil,
            bottomButton: BottomButton? = nil,
            backgroundColor: UIColor = .clear,
            shadow: Shadow? = nil,
            cornerRadius: CGFloat = 0,
            additionalOffset: CGFloat = 16,
            verticalStackSpacing: CGFloat = .zero,
            horizontalStackViewSpacing: CGFloat = 12,
            height: Int = .zero,
            animationIn: Animation = .init(),
            animationOut: Animation = .init(),
            spacerViewProperties: SpacerView.ViewProperties? = nil,
            stackViewInsets: UIEdgeInsets = .zero,
            containerViewInsets: UIEdgeInsets = .zero,
            animationInsets: UIEdgeInsets = .zero
        ) {
            self.title = title
            self.subtitle = subtitle
            self.icon = icon
            self.closeButton = closeButton
            self.bottomButton = bottomButton
            self.backgroundColor = backgroundColor
            self.shadow = shadow
            self.additionalOffset = additionalOffset
            self.animationIn = animationIn
            self.animationOut = animationOut
            self.spacerViewProperties = spacerViewProperties
            self.verticalStackSpacing = verticalStackSpacing
            self.horizontalStackViewSpacing = horizontalStackViewSpacing
            self.cornerRadius = cornerRadius
            self.stackViewInsets = stackViewInsets
            self.containerViewInsets = containerViewInsets
            self.height = height
            self.animationInsets = animationInsets
        }
        
        public struct Icon {
            public var image: UIImage
            public var size: CGSize
            
            public init(
                image: UIImage = .init(),
                size: CGSize = .zero
            ) {
                self.image = image
                self.size = size
            }
        }
        
        public struct CloseButton {
            public var icon: UIImage
            public var size: CGSize
            public var action: () -> Void
            
            public init(
                icon: UIImage = .init(),
                size: CGSize = .zero,
                action: @escaping () -> Void = { }
            ) {
                self.icon = icon
                self.size = size
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
    
    // MARK: - Private properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    private lazy var bottomButton: UIButton = {
        let button = CorrectHeightButton()
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            spacerView,
            bottomButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            iconImageView,
            vStackView,
            closeButton
        ])
        stackView.axis = .horizontal
        stackView.alignment = .top

        return stackView
    }()
    
    private lazy var containerView = UIView()
    private lazy var spacerView = SpacerView()
    private lazy var iconImageView = UIImageView()
    private lazy var closeButton = UIButton(type: .custom)
    
    private var viewProperties: ViewProperties = .init()

    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
       
        containerView.backgroundColor = viewProperties.backgroundColor
        containerView.layer.cornerRadius = viewProperties.cornerRadius
        setupView(viewProperties: viewProperties)
        updateLabel(titleLabel, text: viewProperties.title)
        updateLabel(subtitleLabel, text: viewProperties.subtitle)
        updateCloseButton(viewProperties.closeButton)
        updateBottomButton(viewProperties.bottomButton)
        updateSpacerView(with: viewProperties)
        updateShadow(viewProperties.shadow)
        updateIconImageView(icon: viewProperties.icon)
    }
    
    public func show(on view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(self.viewProperties.animationInsets)
            $0.top.equalTo(view.snp.bottom).inset(self.viewProperties.animationInsets)
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
    
    private func setupView(viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(viewProperties.containerViewInsets)
            make.height.lessThanOrEqualTo(viewProperties.height)
        }
        
        containerView.addSubview(hStackView)
        hStackView.spacing = viewProperties.horizontalStackViewSpacing
        vStackView.spacing = viewProperties.verticalStackSpacing
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.stackViewInsets)
        }
        
        bringSubviewToFront(closeButton)
    }
    
    private func updateIconImageView(icon: ViewProperties.Icon) {
        iconImageView.image = icon.image
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(icon.size)
        }
    }
    
    private func updateLabel(_ label: UILabel, text: NSAttributedString?) {
        label.attributedText = text
        label.isHidden = text == nil
    }
    
    private func updateBottomButton(_ button: ViewProperties.BottomButton?) {
        bottomButton.setAttributedTitle(button?.title, for: .normal)
        bottomButton.isHidden = button == nil
        bottomButton.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
    }
    
    private func updateSpacerView(with viewProperties: ViewProperties) {
        spacerView.isHidden = viewProperties.bottomButton == nil
            || viewProperties.title == nil
            && viewProperties.subtitle == nil
        
        guard let spacerViewProperties = viewProperties.spacerViewProperties else { return }
        
        spacerView.update(with: spacerViewProperties)
    }

    private func updateCloseButton(_ button: ViewProperties.CloseButton?) {
        closeButton.setImage(button?.icon, for: .normal)
        closeButton.isHidden = button == nil
        
        guard let button = button else { return }
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.snp.makeConstraints {
            $0.size.equalTo(button.size)
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
    
    private func removeConstraintsAndSubviews() {
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }

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
                    y: -offset
                )
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

// MARK: - CorrectHeightButton

/// Кнопка-лейбл с высотой, равной высоте titleLabel
/// (без лишних отступов по вертикали)
public final class CorrectHeightButton: UIButton {
    public override var intrinsicContentSize: CGSize {
        guard let titleLabel = titleLabel else { return .zero }
        
        let labelSize = titleLabel.sizeThatFits(
            CGSize(
                width: frame.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        let desiredButtonSize = CGSize(
            width: labelSize.width,
            height: labelSize.height
        )
        
        return desiredButtonSize
    }
}
