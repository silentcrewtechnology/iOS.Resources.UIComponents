import UIKit

public struct MoleculeService {
    
    // MARK: - Private properties
    
    private let atomService = AtomService()
    private let connectionService = ViewsConnectionService()
    
    // MARK: - Life cycle
    
    public init() { }
    
    // MARK: - Methods
    
    public func createMolecule(_ molecule: Molecule) -> UIView {
        switch molecule {
        case .titleWithSubtitle(let titleViewProperties, let subtitleViewProperties):
            return createTitleWithSubtitle(titleViewProperties, subtitleViewProperties)
        case .titleWithSubtitles(let titleViewProperties, let subtitlesViewProperties):
            return createTitleWithSubtitles(titleViewProperties, subtitlesViewProperties)
        case .subtitleWithTitle(let subtitleViewProperties, let titleViewProperties):
            return createSubtitleWithTitle(subtitleViewProperties, titleViewProperties)
        case .icons20(let iconsViewProperties):
            return createIcons20(iconsViewProperties)
        case .indexWithIcon24(let indexViewProperties, let iconViewProperties):
            return createIndexWithIcon24(indexViewProperties, iconViewProperties)
        case .indexWithIcons20(let indexViewProperties, let iconsViewProperties):
            return createIndexWithIcons20(indexViewProperties, iconsViewProperties)
        case .indexWithToggle(let indexViewProperties, let toggleViewProperties):
            return createIndexWithToggle(indexViewProperties, toggleViewProperties)
        case .buttonWithSubtitle(let buttonViewPropeties, let labelViewProperties):
            return createButtonWithSubtitle(buttonViewPropeties, labelViewProperties)
        }
    }
}

// MARK: - Molecules creation

private extension MoleculeService {
    private func createTitleWithSubtitle(
        _ titleText: LabelView.ViewProperties,
        _ subtitleText: LabelView.ViewProperties
    ) -> UIView {
        let titleLabel = atomService.createAtom(.title(titleText))
        let subtitleLabel = atomService.createAtom(.subtitle(titleText))
        
        return connectionService.connect(topView: titleLabel, bottomView: subtitleLabel)
    }
    
    private func createSubtitleWithTitle(
        _ subtitleText: LabelView.ViewProperties,
        _ titleText: LabelView.ViewProperties
    ) -> UIView {
        let subtitleLabel = atomService.createAtom(.subtitle(subtitleText))
        let titleLabel = atomService.createAtom(.title(titleText))
        
        return connectionService.connect(topView: subtitleLabel, bottomView: titleLabel)
    }
    
    private func createIcons20(
        _ icons: [ImageView.ViewProperties]
    ) -> UIView {
        var atomsFromIcons: [UIView] = []
        
        for icon in icons {
            let iconAtom = atomService.createAtom(.icon20(icon))
            atomsFromIcons.append(iconAtom)
        }
        
        return connectionService.connect(horizontalyViews: atomsFromIcons)
    }
    
    private func createIndexWithIcon24(
        _ indexText: LabelView.ViewProperties,
        _ icon: ImageView.ViewProperties
    ) -> UIView {
        let indexLabel = atomService.createAtom(.index(indexText))
        let icon = atomService.createAtom(.icon24(icon))
        
        return connectionService.connect(leftView: indexLabel, rightView: icon)
    }
    
    private func createIndexWithIcons20(
        _ indexText: LabelView.ViewProperties,
        _ icons: [ImageView.ViewProperties]
    ) -> UIView {
        let indexLabel = atomService.createAtom(.index(indexText))
        
        var atomsFromIcons: [UIView] = []
        for icon in icons {
            let iconAtom = atomService.createAtom(.icon20(icon))
            atomsFromIcons.append(iconAtom)
        }
        let iconsResult = connectionService.connect(horizontalyViews: atomsFromIcons)
        
        return connectionService.connect(topView: indexLabel, bottomView: iconsResult)
    }
    
    private func createIndexWithToggle(
        _ indexText: LabelView.ViewProperties,
        _ toggle: ToggleView.ViewProperties
    ) -> UIView {
        let indexLabel = atomService.createAtom(.index(indexText))
        let switchView = atomService.createAtom(.toggle(toggle))
        
        return connectionService.connect(leftView: indexLabel, rightView: switchView)
    }
    
    private func createButtonWithSubtitle(
        _ button: ButtonView.ViewProperties,
        _ subtitleText: LabelView.ViewProperties
    ) -> UIView {
        let buttonView = atomService.createAtom(.button(button))
        let subtitleLabel = atomService.createAtom(.subtitle(subtitleText))
        
        return connectionService.connect(topView: buttonView, bottomView: subtitleLabel)
    }
    
    private func createTitleWithSubtitles(
        _ titleText: LabelView.ViewProperties,
        _ subtitlesText: [LabelView.ViewProperties]
    ) -> UIView {
        let titleLabel = atomService.createAtom(.title(titleText))
        
        var atomsFromSubtitles: [UIView] = []
        for subtitle in subtitlesText {
            let subtitleText = atomService.createAtom(.subtitle(subtitle))
            atomsFromSubtitles.append(subtitleText)
        }
        let subtitlesResult = connectionService.connect(verticalyViews: atomsFromSubtitles)
        
        return connectionService.connect(topView: titleLabel, bottomView: subtitlesResult)
    }
}
