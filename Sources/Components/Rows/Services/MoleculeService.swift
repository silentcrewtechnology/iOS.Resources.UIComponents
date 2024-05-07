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
        case .titleWithSubtitle(let titleViewProperties, let subtitleViewProperties):
            return createTitleWithSubtitle(titleViewProperties, subtitleViewProperties)
        case .subtitleWithTitle(let subtitleViewProperties, let titleViewProperties):
            return createSubtitleWithTitle(subtitleViewProperties, titleViewProperties)
        case .icons20(let icons):
            return createIcons20(icons)
        case .indexWithcIcon24(let indexViewProperties, let icon):
            return createIndexWithcIcon24(indexViewProperties, icon)
        case .indexWithIcons20(let indexViewProperties, let icons):
            return createIndexWithIcons20(indexViewProperties, icons)
        case .indexWithSwitch(let indexViewProperties):
            return createIndexWithSwitch(indexViewProperties)
        }
    }
}

private extension MoleculeService {
    private func createTitleWithSubtitle(
        _ titleText: LabelView.ViewProperties,
        _ subtitleText: LabelView.ViewProperties
    ) -> UIView {
        let atomService = AtomService()
        
        let titleLabel = atomService.createAtom(.title(titleText))
        let subtitleLabel = atomService.createAtom(.subtitle(titleText))
        
        return connect(top: titleLabel, bottom: subtitleLabel)
    }
    
    private func createSubtitleWithTitle(
        _ subtitleText: LabelView.ViewProperties,
        _ titleText: LabelView.ViewProperties
    ) -> UIView {
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
    
    private func createIndexWithcIcon24(
        _ indexText: LabelView.ViewProperties,
        _ icon: UIImage
    ) -> UIView {
        let atomService = AtomService()
        
        let indexLabel = atomService.createAtom(.index(indexText))
        let icon = atomService.createAtom(.icon24(icon))
        
        return connect(left: indexLabel, right: icon)
    }
    
    private func createIndexWithIcons20(
        _ indexText: LabelView.ViewProperties,
        _ icons: [UIImage]
    ) -> UIView {
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
    
    private func createIndexWithSwitch(_ indexText: LabelView.ViewProperties) -> UIView {
        let atomService = AtomService()
        
        let indexLabel = atomService.createAtom(.index(indexText))
        let switchView = atomService.createAtom(.switch)
        
        return connect(left: indexLabel, right: switchView)
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
