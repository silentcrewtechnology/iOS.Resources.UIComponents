//
//  MoleculeService.swift
//
//
//  Created by Омельченко Юлия on 18.04.2024.
//

import UIKit

public final class MoleculeService {
    public func createMolecule(_ molecule: Molecule) -> UIView {
        switch molecule {
        case .titleWithSubtitle(let titleText, let subtitleText):
            return createTitleWithSubtitle(titleText, subtitleText)
        case .subtitleWithTitle(let subtitleText, let titleText):
            return createSubtitleWithTitle(subtitleText, titleText)
        case .icons20(let icons):
            return createIcons20(icons)
        case .indexWithcIcon24(let indexText, let icon):
            return createIndexWithcIcon24(indexText, icon)
        case .indexWithIcons20(let indexText, let icons):
            return createIndexWithIcons20(indexText, icons)
        case .indexWithSwitch(let indexText, let action):
            return createIndexWithSwitch(indexText, action)
        case .amountTextWithColoredPrefix(let amountText, let coloredText):
            return createAmountTextWithColoredPrefix(amountText, coloredText)
        case .amountTextWithTextButton(let amountText, let buttonText, let action):
            return createAmountTextWithTextButton(amountText, buttonText, action)
        }
    }
}

private extension MoleculeService {
    private func createTitleWithSubtitle(_ titleText: NSAttributedString,
                                         _ subtitleText: NSAttributedString) -> UIView {
        let atomService = AtomService()
        
        let titleLabel = atomService.createAtom(.title(titleText))
        let subtitleLabel = atomService.createAtom(.subtitle(titleText))
        
        return connect(top: titleLabel, bottom: subtitleLabel)
    }
    
    private func createSubtitleWithTitle(_ subtitleText: NSAttributedString,
                                         _ titleText: NSAttributedString) -> UIView {
        let atomService = AtomService()
        
        let subtitleLabel = atomService.createAtom(.subtitle(subtitleText))
        let titleLabel = atomService.createAtom(.title(titleText))
        
        return connect(top: subtitleLabel, bottom: titleLabel)
    }
    
    private func createIcons20(_ icons: [UIImage]) -> UIView {
        let atomService = AtomService()
        
        var atomsFromIcons: [UIView] = []
        
        for icon in icons {
            let iconAtom = atomService.createAtom(.icon20(icon))
            atomsFromIcons.append(iconAtom)
        }
        
        return connect(horizontalyViews: atomsFromIcons)
    }
    
    private func createIndexWithcIcon24(_ indexText: NSAttributedString,
                                        _ icon: UIImage) -> UIView {
        let atomService = AtomService()
        
        let indexLabel = atomService.createAtom(.index(indexText))
        let icon = atomService.createAtom(.icon24(icon))
        
        return connect(left: indexLabel, right: icon)
    }
    
    private func createIndexWithIcons20(_ indexText: NSAttributedString,
                                        _ icons: [UIImage]) -> UIView {
        let atomService = AtomService()
        
        let indexLabel = atomService.createAtom(.index(indexText))
        
        var atomsFromIcons: [UIView] = []
        for icon in icons {
            let iconAtom = atomService.createAtom(.icon20(icon))
            atomsFromIcons.append(iconAtom)
        }
        let iconsResult = connect(horizontalyViews: atomsFromIcons)
        
        return connect(top: indexLabel, bottom: iconsResult)
    }
    
    private func createIndexWithSwitch(_ indexText: NSAttributedString,
                                       _ action: @escaping () -> Bool) -> UIView {
        let atomService = AtomService()
        
        let indexLabel = atomService.createAtom(.index(indexText))
        let switchView = atomService.createAtom(.switch(action))
        
        return connect(left: indexLabel, right: switchView)
    }
    
    private func createAmountTextWithColoredPrefix(_ amountText: NSAttributedString,
                                                   _ coloredText: NSAttributedString) -> UIView {
        let atomService = AtomService()
        
        let amountLabel = atomService.createAtom(.amountText(amountText))
        let coloredLabel = atomService.createAtom(.coloredPrefix(coloredText))
        
        return connect(top: amountLabel, bottom: coloredLabel)
    }
    
    private func createAmountTextWithTextButton(_ amountText: NSAttributedString,
                                                _ buttonText: NSAttributedString,
                                                _ action: @escaping () -> Void) -> UIView {
        let atomService = AtomService()
        
        let amountLabel = atomService.createAtom(.amountText(amountText))
        let textButton = atomService.createAtom(.textButton(buttonText, action))
        
        return connect(top: amountLabel, bottom: textButton)
    }
}

private extension MoleculeService {
    private func connect(top: UIView, bottom: UIView) -> UIView {
        return UIView()
    }
    
    private func connect(left: UIView, right: UIView) -> UIView {
        return UIView()
    }
    
    private func connect(horizontalyViews: [UIView]) -> UIView {
        return UIView()
    }
}
