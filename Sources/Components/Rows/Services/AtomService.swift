//
//  AtomService.swift
//
//
//  Created by Омельченко Юлия on 18.04.2024.
//

import UIKit

public final class AtomService {
    
    public func createAtom(_ atom: Atom) -> UIView {
        switch atom {
        case .title(let text):
            return createTitle(text)
        case .subtitle(let text):
            return createSubtitle(text)
        case .image(let image):
            return createImage(image)
        case .index(let text):
            return createIndex(text)
        case .icon24(let image):
            return createIcon24(image)
        case .icon20(let image):
            return createIcon20(image)
        case .switch(let action):
            return createSwitch(action)
        case .chips(let action):
            return createChips(action)
        case .amountText(let text):
            return createAmountText(text)
        case .checkbox(let action):
            return createCheckbox(action)
        case .radio(let action):
            return createRadio(action)
        case .textButton(let text, let action):
            return createTextButton(text, action)
        case .coloredPrefix(let text):
            return createColoredPrefix(text)
        case .copyText(let text):
            return createCopyText(text)
        }
    }
}

private extension AtomService {
    private func createTitle(_ text: NSAttributedString) -> UIView {
        let label = UILabel()
        label.attributedText = text
        return label
    }
    
    private func createSubtitle(_ text: NSAttributedString) -> UIView {
        let label = UILabel()
        label.attributedText = text
        return label
    }
    
    private func createImage(_ image: UIImage) -> UIView {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
    }
    
    private func createIndex(_ text: NSAttributedString) -> UIView {
        let label = UILabel()
        label.attributedText = text
        return label
    }
    
    private func createIcon24(_ image: UIImage) -> UIView {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
    }
    
    private func createIcon20(_ image: UIImage) -> UIView {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
    }
    
    private func createSwitch(_ action: () -> Bool) -> UIView {
        let switchButton = UISwitch()
        // TODO: add Action
        // switchButton.target(forAction: <#T##Selector#>, withSender: <#T##Any?#>)
        return switchButton
    }
    
    private func createChips(_ action: () -> Void) -> UIView {
        let chips = ChipsView()
        // TODO: add Action
        return chips
    }
    
    private func createAmountText(_ text: NSAttributedString) -> UIView {
        let label = UILabel()
        label.attributedText = text
        return label
    }
    
    private func createCheckbox(_ action: () -> Bool) -> UIView {
        let checkbox = CheckboxView()
        // TODO: add Action
        return checkbox
    }
    
    private func createRadio(_ action: () -> Bool) -> UIView {
        let radio = RadioView()
        // TODO: add Action
        return radio
    }
    
    private func createTextButton(_ text: NSAttributedString,
                                  _ action: () -> Void) -> UIView {
        let label = UILabel()
        label.attributedText = text
        // TODO: add Action
        return label
    }
    
    private func createColoredPrefix(_ text: NSAttributedString) -> UIView {
        let label = UILabel()
        label.attributedText = text
        return label
    }
    
    private func createCopyText(_ text: NSAttributedString) -> UIView {
        let label = UILabel()
        label.attributedText = text
        return label
    }
}
