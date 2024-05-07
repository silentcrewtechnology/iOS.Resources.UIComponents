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
        case .title(let viewProperties):
            return createTitle(viewProperties)
        case .subtitle(let viewProperties):
            return createSubtitle(viewProperties)
        case .image40(let image):
            return createImage(image)
        case .image40x48(let image):
            return createImage(image)
        case .index(let viewProperties):
            return createIndex(viewProperties)
        case .icon24(let image):
            return createIcon24(image)
        case .icon20(let image):
            return createIcon20(image)
        case .switch:
            return createSwitch()
        case .amountText(let viewProperties):
            return createAmountText(viewProperties)
        case .checkbox(let viewProperties):
            return createCheckbox(viewProperties)
        case .radio(let viewProperties):
            return createRadio(viewProperties)
        case .button(let text):
            return createButton(text)
        case .copyText(let viewProperties):
            return createCopyText(viewProperties)
        }
    }
}

private extension AtomService {
    private func createTitle(_ viewProperties: LabelView.ViewProperties) -> UIView {
        let label = LabelView()
        label.update(with: viewProperties)
        return label
    }
    
    private func createSubtitle(_ viewProperties: LabelView.ViewProperties) -> UIView {
        let label = LabelView()
        label.update(with: viewProperties)
        return label
    }
    
    private func createImage(_ image: UIImage) -> UIView {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
    }
    
    private func createIndex(_ viewProperties: LabelView.ViewProperties) -> UIView {
        let label = LabelView()
        label.update(with: viewProperties)
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
    
    private func createSwitch() -> UIView {
        let switchButton = UISwitch()
        return switchButton
    }
    
    private func createAmountText(_ viewProperties: LabelView.ViewProperties) -> UIView {
        let label = LabelView()
        label.update(with: viewProperties)
        return label
    }
    
    private func createCheckbox(_ viewProperties: CheckboxView.ViewProperties) -> UIView {
        let checkbox = CheckboxView()
        checkbox.update(with: viewProperties)
        return checkbox
    }
    
    private func createRadio(_ viewProperties: RadioView.ViewProperties) -> UIView {
        let radio = RadioView()
        radio.update(with: viewProperties)
        return radio
    }
    
    private func createButton(_ viewProperties: ButtonView.ViewProperties) -> UIView {
        let button = ButtonView()
        button.update(with: viewProperties)
        return button
    }
    
    private func createCopyText(_ viewProperties: LabelView.ViewProperties) -> UIView {
        let label = LabelView()
        label.update(with: viewProperties)
        return label
    }
}
