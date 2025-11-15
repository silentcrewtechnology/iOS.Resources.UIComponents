//
//  InputSearchView.swift
//
//
//  Created by user on 21.10.2024.
//

import UIKit
import SnapKit

public final class InputSearchView: UISearchBar, ComponentProtocol {
    
    public struct ViewProperties {
        public var isHidden: Bool
        public var isUserInteractionEnabled: Bool
        public var cancelButtonAttributes: [NSAttributedString.Key: Any]?
        public var searchBar: SearchBar
        public var textField: TextField
        public var cancelButtonText: String
        public var cancelButtonTextKey: String
        public var textDidChange: ((String) -> Void)?
        public var cancelButtonClicked: (() -> Void)?
        public var textDidBeginEditing: (() -> Void)?
        public var textDidEndEditing: (() -> Void)?
        
        public struct SearchBar {
            public var searchBarStyle: UISearchBar.Style
            public var tintColor: UIColor
            public var backgroundImage: UIImage
            public var clearImage: UIImage
            public var searchImage: UIImage
            public var layerShadowColor: CGColor
            
            public init(
                searchBarStyle: UISearchBar.Style = .default,
                tintColor: UIColor = .clear,
                backgroundImage: UIImage = .init(),
                clearImage: UIImage = .init(),
                searchImage: UIImage = .init(),
                layerShadowColor: CGColor = UIColor.clear.cgColor
            ) {
                self.searchBarStyle = searchBarStyle
                self.tintColor = tintColor
                self.backgroundImage = backgroundImage
                self.clearImage = clearImage
                self.searchImage = searchImage
                self.layerShadowColor = layerShadowColor
            }
        }
        
        public struct TextField {
            public var backgroundColor: UIColor
            public var textColor: UIColor
            public var layerBorderColor: CGColor
            public var placeholder: NSMutableAttributedString?
            public var text: String?
            public var textFieldKey: String
            public var font: UIFont?
            public var layerBorderWidth: CGFloat
            public var layerCornerRadius: CGFloat
            
            public init(
                backgroundColor: UIColor = .clear,
                textColor: UIColor = .clear,
                layerBorderColor: CGColor = UIColor.clear.cgColor,
                placeholder: NSMutableAttributedString? = nil,
                text: String? = nil,
                textFieldKey: String = .init(),
                font: UIFont? = nil,
                layerBorderWidth: CGFloat = .zero,
                layerCornerRadius: CGFloat = .zero
            ) {
                self.backgroundColor = backgroundColor
                self.textColor = textColor
                self.layerBorderColor = layerBorderColor
                self.placeholder = placeholder
                self.text = text
                self.textFieldKey = textFieldKey
                self.font = font
                self.layerBorderWidth = layerBorderWidth
                self.layerCornerRadius = layerCornerRadius
            }
        }
        
        public init(
            isHidden: Bool = false,
            isUserInteractionEnabled: Bool = true,
            cancelButtonAttributes: [NSAttributedString.Key: Any]? = nil,
            searchBar: SearchBar = .init(),
            textField: TextField = .init(),
            cancelButtonText: String = .init(),
            cancelButtonTextKey: String = .init(),
            textDidChange: ((String) -> Void)? = nil,
            cancelButtonClicked: (() -> Void)? = nil,
            textDidBeginEditing: (() -> Void)? = nil,
            textDidEndEditing: (() -> Void)? = nil
        ) {
            self.isHidden = isHidden
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.searchBar = searchBar
            self.textField = textField
            self.cancelButtonText = cancelButtonText
            self.cancelButtonTextKey = cancelButtonTextKey
            self.textDidChange = textDidChange
            self.cancelButtonClicked = cancelButtonClicked
            self.textDidBeginEditing = textDidBeginEditing
            self.textDidEndEditing = textDidEndEditing
        }
    }
    
    // MARK: - Private Properties
    
    private var viewProperties: ViewProperties = .init()

    // MARK: - Public Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setupView(with: viewProperties)
        setupSearchBar(with: viewProperties.searchBar)
        setupTextField(with: viewProperties.textField)
    }
    
    // MARK: - Private Methods
    
    private func setupView(with viewProperties: ViewProperties) {
        isHidden = viewProperties.isHidden
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        UIBarButtonItem.appearance().setTitleTextAttributes(viewProperties.cancelButtonAttributes, for: .normal)
        setValue(viewProperties.cancelButtonText, forKey: viewProperties.cancelButtonTextKey)
        
        delegate = self
    }
    
    private func setupSearchBar(with searchBar: ViewProperties.SearchBar) {
        searchBarStyle = searchBar.searchBarStyle
        tintColor = searchBar.tintColor
        backgroundImage = searchBar.backgroundImage
        layer.shadowColor = searchBar.layerShadowColor
        setImage(searchBar.clearImage, for: .clear, state: .normal)
        setImage(searchBar.searchImage, for: .search, state: .normal)
    }
    
    private func setupTextField(with textField: ViewProperties.TextField) {
        if let textfield = value(forKey: textField.textFieldKey) as? UITextField {
            textfield.attributedPlaceholder = textField.placeholder
            textfield.text = textField.text
            textfield.textColor = textfield.textColor
            textfield.font = textField.font
            textfield.layer.borderWidth = textField.layerBorderWidth
            textfield.layer.cornerRadius = textField.layerCornerRadius
            
            UIView.animate(withDuration: 0.1) {
                textfield.backgroundColor = textField.backgroundColor
                textfield.layer.borderColor = textField.layerBorderColor
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension InputSearchView: UISearchBarDelegate {
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text?.removeAll()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        viewProperties.cancelButtonClicked?()
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        viewProperties.textDidBeginEditing?()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        viewProperties.textDidEndEditing?()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewProperties.textDidChange?(searchText)
    }
}
