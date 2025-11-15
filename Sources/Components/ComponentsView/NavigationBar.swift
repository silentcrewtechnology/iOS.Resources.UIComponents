//
//  NavigationBar.swift
//  
//
//  Created by user on 22.07.2024.
//

import UIKit

public final class NavigationBar: UINavigationController, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties: Equatable {
        public var leftBarButtonItems: [UIBarButtonItem]?
        public var rightBarButtonItems: [UIBarButtonItem]?
        public var titleView: UIView?
        public var title: String?
        public var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode
        public var prefersLargeTitles: Bool
        public var standartAppearance: UINavigationBarAppearance
        public var compactAppearance: UINavigationBarAppearance?
        public var scrollEdgeAppearance: UINavigationBarAppearance?
        public var searchController: UISearchController?
        public var hidesSearchBarWhenScrolling: Bool
        public var isNavigationBarHidden: Bool
        public var accessibilityId: String?
        
        public init(
            leftBarButtonItems: [UIBarButtonItem]? = nil,
            rightBarButtonItems: [UIBarButtonItem]? = nil,
            titleView: UIView? = nil, 
            title: String? = nil,
            largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode = .automatic,
            prefersLargeTitles: Bool = false,
            standartAppearance: UINavigationBarAppearance = .init(),
            compactAppearance: UINavigationBarAppearance? = nil,
            scrollEdgeAppearance: UINavigationBarAppearance? = nil,
            searchController: UISearchController? = nil,
            hidesSearchBarWhenScrolling: Bool = true,
            isNavigationBarHidden: Bool = false,
            accessibilityId: String? = nil
        ) {
            self.leftBarButtonItems = leftBarButtonItems
            self.rightBarButtonItems = rightBarButtonItems
            self.titleView = titleView
            self.title = title
            self.largeTitleDisplayMode = largeTitleDisplayMode
            self.prefersLargeTitles = prefersLargeTitles
            self.standartAppearance = standartAppearance
            self.compactAppearance = compactAppearance
            self.scrollEdgeAppearance = scrollEdgeAppearance
            self.searchController = searchController
            self.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
            self.isNavigationBarHidden = isNavigationBarHidden
            self.accessibilityId = accessibilityId
        }
        
        public static func == (
            lhs: NavigationBar.ViewProperties,
            rhs: NavigationBar.ViewProperties
        ) -> Bool {
            return lhs.leftBarButtonItems == rhs.leftBarButtonItems
                && lhs.rightBarButtonItems == rhs.rightBarButtonItems
                && lhs.titleView == rhs.titleView
                && lhs.title == rhs.title
                && lhs.largeTitleDisplayMode == rhs.largeTitleDisplayMode
                && lhs.prefersLargeTitles == rhs.prefersLargeTitles
                && lhs.standartAppearance == rhs.standartAppearance
                && lhs.compactAppearance == rhs.compactAppearance
                && lhs.scrollEdgeAppearance == rhs.scrollEdgeAppearance
                && lhs.searchController == rhs.searchController
                && lhs.hidesSearchBarWhenScrolling == rhs.hidesSearchBarWhenScrolling
                && lhs.isNavigationBarHidden == rhs.isNavigationBarHidden
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        isNavigationBarHidden = viewProperties.isNavigationBarHidden
        updateNavigationBar(with: viewProperties)
        updateNavigationItem(with: viewProperties)
        setupAccessibilityId(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func updateNavigationBar(with viewProperties: ViewProperties) {
        navigationBar.prefersLargeTitles = viewProperties.prefersLargeTitles
        navigationBar.standardAppearance = viewProperties.standartAppearance
        navigationBar.scrollEdgeAppearance = viewProperties.scrollEdgeAppearance
        navigationBar.compactAppearance = viewProperties.compactAppearance
    }
    
    private func updateNavigationItem(with viewProperties: ViewProperties) {
        visibleViewController?.navigationItem.leftBarButtonItems = viewProperties.leftBarButtonItems
        visibleViewController?.navigationItem.rightBarButtonItems = viewProperties.rightBarButtonItems
        visibleViewController?.navigationItem.titleView = viewProperties.titleView
        visibleViewController?.navigationItem.title = viewProperties.title
        visibleViewController?.navigationItem.largeTitleDisplayMode = viewProperties.largeTitleDisplayMode
        visibleViewController?.navigationItem.searchController = viewProperties.searchController
        visibleViewController?.navigationItem.hidesSearchBarWhenScrolling = viewProperties.hidesSearchBarWhenScrolling
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        view.accessibilityIdentifier = viewProperties.accessibilityId
    }
}
