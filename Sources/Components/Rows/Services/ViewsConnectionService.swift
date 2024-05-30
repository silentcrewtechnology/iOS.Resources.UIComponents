//
//  ViewsConnectionService.swift
//
//
//  Created by user on 30.05.2024.
//

import UIKit
import SnapKit

public struct ViewsConnectionService {
    
    // MARK: - Life cycle
    
    public init() { }
    
    // MARK: - Methods
    
    public func connect(topView: UIView, bottomView: UIView) -> UIView {
        let containerView = UIView()
        
        containerView.addSubview(topView)
        containerView.addSubview(bottomView)
        
        topView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        return containerView
    }
    
    public func connect(leftView: UIView, rightView: UIView, spacing: Int = .zero) -> UIView {
        let containerView = UIView()
        
        containerView.addSubview(leftView)
        containerView.addSubview(rightView)
        
        leftView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }
        
        rightView.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.left.equalTo(leftView.snp.right).offset(spacing)
        }
        
        return containerView
    }
    
    public func connect(horizontalyViews: [UIView]) -> UIView {
        let containerView = UIView()
        
        guard !horizontalyViews.isEmpty else {
            return containerView
        }
        
        for (index, view) in horizontalyViews.enumerated() {
            containerView.addSubview(view)
            
            view.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                
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
    
    public func connect(verticalyViews: [UIView]) -> UIView {
        let containerView = UIView()
        
        guard !verticalyViews.isEmpty else {
            return containerView
        }
        
        for (index, view) in verticalyViews.enumerated() {
            containerView.addSubview(view)
            
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                
                if index == 0 {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(verticalyViews[index - 1].snp.bottom)
                }
                
                if index == verticalyViews.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
        }
        
        return containerView
    }
}

