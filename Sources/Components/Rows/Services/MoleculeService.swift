import UIKit

public struct MoleculeService {
    
    // MARK: - Private properties
    
    private let atomService = AtomService()
    
    // MARK: - Life cycle
    
    public init() { }
    
    // MARK: - Methods
    
    public func createMolecule(_ molecule: Molecule) -> UIView {
        switch molecule {
        case .titleWithSubtitle(let titleViewProperties, let subtitleViewProperties):
            return createTitleWithSubtitle(titleViewProperties, subtitleViewProperties)
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
        case .buttonWithSubindex(let buttonViewPropeties, let labelViewProperties):
            return createButtonWithSubindex(buttonViewPropeties, labelViewProperties)
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
        
        return connect(topView: titleLabel, bottomView: subtitleLabel)
    }
    
    private func createSubtitleWithTitle(
        _ subtitleText: LabelView.ViewProperties,
        _ titleText: LabelView.ViewProperties
    ) -> UIView {
        let subtitleLabel = atomService.createAtom(.subtitle(subtitleText))
        let titleLabel = atomService.createAtom(.title(titleText))
        
        return connect(topView: subtitleLabel, bottomView: titleLabel)
    }
    
    private func createIcons20(
        _ icons: [ImageView.ViewProperties]
    ) -> UIView {
        var atomsFromIcons: [UIView] = []
        
        for icon in icons {
            let iconAtom = atomService.createAtom(.icon20(icon))
            atomsFromIcons.append(iconAtom)
        }
        
        return connect(horizontalyViews: atomsFromIcons)
    }
    
    private func createIndexWithIcon24(
        _ indexText: LabelView.ViewProperties,
        _ icon: ImageView.ViewProperties
    ) -> UIView {
        let indexLabel = atomService.createAtom(.index(indexText))
        let icon = atomService.createAtom(.icon24(icon))
        
        return connect(leftView: indexLabel, rightView: icon)
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
        let iconsResult = connect(horizontalyViews: atomsFromIcons)
        
        return connect(topView: indexLabel, bottomView: iconsResult)
    }
    
    private func createIndexWithToggle(
        _ indexText: LabelView.ViewProperties,
        _ toggle: ToggleView.ViewProperties
    ) -> UIView {
        let indexLabel = atomService.createAtom(.index(indexText))
        let switchView = atomService.createAtom(.toggle(toggle))
        
        return connect(leftView: indexLabel, rightView: switchView)
    }
    
    private func createButtonWithSubindex(
        _ button: ButtonView.ViewProperties,
        _ subindexText: LabelView.ViewProperties
    ) -> UIView {
        let buttonView = atomService.createAtom(.button(button))
        let subindexLabel = atomService.createAtom(.subindex(subindexText))
        
        return connect(topView: buttonView, bottomView: subindexLabel)
    }
}

// MARK: - Views connection

private extension MoleculeService {
    private func connect(topView: UIView, bottomView: UIView) -> UIView {
        let containerView = UIView()
        
        containerView.addSubview(topView)
        containerView.addSubview(bottomView)
        
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return containerView
    }
    
    private func connect(leftView: UIView, rightView: UIView) -> UIView {
        let containerView = UIView()
        
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        
        leftView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        rightView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(leftView.snp.right)
            make.right.equalToSuperview()
        }
        
        return containerView
    }
    
    private func connect(horizontalyViews: [UIView]) -> UIView {
        let containerView = UIView()
        
        guard !horizontalyViews.isEmpty else {
            return containerView
        }
        
        for (index, view) in horizontalyViews.enumerated() {
            containerView.addSubview(view)
            
            view.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                
                if index == 0 {
                    make.left.equalToSuperview()
                } else {
                    make.left.equalTo(horizontalyViews[index - 1].snp.right)
                }
                
                if index == horizontalyViews.count - 1 {
                    make.right.equalToSuperview()
                }
            }
        }
        
        return containerView
    }
}
