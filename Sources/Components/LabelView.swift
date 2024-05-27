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
        public var isCopied: Bool
        
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
            size: Size = .init(),
            isCopied: Bool = false
        ) {
            self.text = text
            self.size = size
            self.isCopied = isCopied
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    private var textToCopy: String?
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        gesture.minimumPressDuration = 0.3
        gesture.cancelsTouchesInView = false
        gesture.numberOfTouchesRequired = 1
        
        return gesture
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
        updateCopy(with: viewProperties.isCopied)
        
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
    
    private func updateCopy(with isCopied: Bool) {
        isCopied
            ? addGestureRecognizer(longPressGesture)
            : removeGestureRecognizer(longPressGesture)
    }
    
    private func setupView() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0) // будет обновлено
            $0.edges.equalToSuperview().inset(0) // будет обновлено
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            becomeFirstResponder()
            
            let copyItem = UIMenuItem(title: Constants.copyTitle, action: #selector(copyText))
            UIMenuController.shared.menuItems?.removeAll()
            UIMenuController.shared.menuItems = [copyItem]
            UIMenuController.shared.update()

            let location = gesture.location(in: gesture.view)
            let menuLocation = CGRect(x: location.x, y: location.y, width: 0, height: 0)
            UIMenuController.shared.showMenu(from: gesture.view!, rect: menuLocation)
          
            textToCopy = viewProperties.text.string
        }
    }
    
    @objc private func copyText() {
        UIPasteboard.general.string = textToCopy
    }
}

// MARK: - Constants

private enum Constants {
    static let copyTitle = "Скопировать"
}
