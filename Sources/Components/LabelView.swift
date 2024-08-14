//
//  LabelView.swift
//
//
//  Created by Ilnur Mugaev on 16.04.2024.
//

import UIKit
import SnapKit

public class LabelView: UIView {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var size: Size
        public var accessibilityIds: AccessibilityIds?
        public var longPressGestureViewProperties: LongPressGestureViewProperties?
        
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
        
        public struct AccessibilityIds {
            public var id: String
            public var labelViewId: String
            
            public init(id: String, labelViewId: String) {
                self.id = id
                self.labelViewId = labelViewId
            }
        }
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            size: Size = .init(),
            accessibilityIds: AccessibilityIds? = nil,
            longPressGestureViewProperties: LongPressGestureViewProperties? = nil
        ) {
            self.text = text
            self.size = size
            self.longPressGestureViewProperties = longPressGestureViewProperties
            self.accessibilityIds = accessibilityIds
        }
        
        public struct LongPressGestureViewProperties {
            public var minimumPressDuration: CGFloat
            public var menuWidth: CGFloat
            public var menuHeight: CGFloat
            public var menuTitle: String
            public var numberOfTouchesRequired: Int
            public var cancelsTouchesInView: Bool
            
            public init(
                minimumPressDuration: CGFloat = .zero,
                menuWidth: CGFloat = .zero,
                menuHeight: CGFloat = .zero,
                menuTitle: String = "",
                numberOfTouchesRequired: Int = .zero,
                cancelsTouchesInView: Bool = false
            ) {
                self.minimumPressDuration = minimumPressDuration
                self.menuWidth = menuWidth
                self.menuHeight = menuHeight
                self.menuTitle = menuTitle
                self.numberOfTouchesRequired = numberOfTouchesRequired
                self.cancelsTouchesInView = cancelsTouchesInView
            }
        }
    }
    // MARK: - Properties
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Private properties
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    private lazy var longPressGesture = UILongPressGestureRecognizer()
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        DispatchQueue.main.async {
            self.viewProperties = viewProperties
            
            self.setupView(size: viewProperties.size)
            self.updateLabel(with: viewProperties.text)
            self.setupAccessibilityIds(with: viewProperties.accessibilityIds)
            
            if let longPressGestureViewProperties = viewProperties.longPressGestureViewProperties {
                self.updateLongGesture(longGestureViewProperties: longPressGestureViewProperties)
            } else {
                self.removeGestureRecognizer(self.longPressGesture)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setupView(size: ViewProperties.Size) {
        removeConstraintsAndSubviews()
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(size.lineHeight)
            $0.edges.equalToSuperview().inset(size.inset)
        }
    }
    
    private func updateLabel(with text: NSMutableAttributedString?) {
        textLabel.attributedText = text
        textLabel.isHidden = text == nil
    }
    
    private func updateLongGesture(
        longGestureViewProperties: ViewProperties.LongPressGestureViewProperties
    ) {
        longPressGesture = .init(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = longGestureViewProperties.minimumPressDuration
        longPressGesture.numberOfTouchesRequired = longGestureViewProperties.numberOfTouchesRequired
        longPressGesture.cancelsTouchesInView = longGestureViewProperties.cancelsTouchesInView
        addGestureRecognizer(longPressGesture)
    }
    
    private func removeConstraintsAndSubviews() {
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    private func setupAccessibilityIds(with accessibilityIds: ViewProperties.AccessibilityIds?) {
        isAccessibilityElement = true
        accessibilityIdentifier = accessibilityIds?.id
        textLabel.accessibilityIdentifier = accessibilityIds?.labelViewId
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began, let gestureViewProperties = viewProperties.longPressGestureViewProperties {
            becomeFirstResponder()
            
            let copyItem = UIMenuItem(title: gestureViewProperties.menuTitle, action: #selector(copyText))
            UIMenuController.shared.menuItems?.removeAll()
            UIMenuController.shared.menuItems = [copyItem]
            UIMenuController.shared.update()
        
            let location = gesture.location(in: gesture.view)
            let menuLocation = CGRect(
                x: location.x,
                y: location.y,
                width: gestureViewProperties.menuWidth,
                height: gestureViewProperties.menuHeight
            )
            UIMenuController.shared.showMenu(from: gesture.view!, rect: menuLocation)
        }
    }
    
    @objc private func copyText() {
        UIPasteboard.general.string = viewProperties.text.string
    }
}
