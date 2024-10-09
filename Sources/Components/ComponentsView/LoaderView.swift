//
//  LoaderView.swift
//
//
//  Created by user on 03.10.2024.
//

import UIKit
import SnapKit

public final class LoaderView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var frame: CGRect
        public var backgroundColor: UIColor
        public var containerInsets: UIEdgeInsets
        public var circleLayer: CircleLayer
        public var rotatingAnimation: RotatingAnimation
        public var strokeAnimation: StrokeAnimation // УКАЗАТЬ
        
        public struct CircleLayer {
            public var strokeColor: UIColor
            public var fillColor: UIColor
            public var backgroundColor: UIColor
            public var lineCap: CAShapeLayerLineCap
            public var lineWidth: CGFloat
            public var strokeStart: CGFloat
            public var strokeEnd: CGFloat
            public var startAngle: CGFloat
            public var endAngle: CGFloat
            public var clockwise: Bool
            public var actions: [String : any CAAction]?
            
            public init(
                strokeColor: UIColor = .clear,
                fillColor: UIColor = .clear,
                backgroundColor: UIColor = .clear,
                lineCap: CAShapeLayerLineCap = .round,
                lineWidth: CGFloat = .zero,
                strokeStart: CGFloat = .zero,
                strokeEnd: CGFloat = 0.05,
                startAngle: CGFloat = .zero,
                endAngle: CGFloat = CGFloat(Double.pi * 2),
                clockwise: Bool = true,
                actions: [String: any CAAction]? = nil
            ) {
                self.strokeColor = strokeColor
                self.fillColor = fillColor
                self.backgroundColor = backgroundColor
                self.lineCap = lineCap
                self.lineWidth = lineWidth
                self.strokeStart = strokeStart
                self.strokeEnd = strokeEnd
                self.startAngle = startAngle
                self.endAngle = endAngle
                self.clockwise = clockwise
                self.actions = actions
            }
        }
        
        public struct RotatingAnimation {
            public var animation: CABasicAnimation
            public var animationKey: String
            
            public init(
                animation: CABasicAnimation = .init(),
                animationKey: String = "rotation"
            ) {
                self.animation = animation
                self.animationKey = animationKey
            }
        }
        
        public struct StrokeAnimation {
            public var progress: CGFloat
            public var transformAngle: CGFloat
            public var transformX: CGFloat
            public var transformY: CGFloat
            public var transformZ: CGFloat
            public var startConstant: CGFloat
            public var endAnimationDuration: CGFloat
            public var startAnimationDuration: CGFloat
            public var endAnimationFillMode: CAMediaTimingFillMode
            public var startAnimationFillMode: CAMediaTimingFillMode
            public var pathAnimationFillMode: CAMediaTimingFillMode
            public var endAnimationBeginTime: CFTimeInterval
            public var startAnimationBeginTimeConstant: CFTimeInterval
            public var endRemovedOnCompletion: Bool
            public var startRemovedOnCompletion: Bool
            public var pathRemovedOnCompletion: Bool
            public var mediaTimingFunction: CAMediaTimingFunction
            public var endAnimationKey: String
            public var startAnimationKey: String
            public var animationKey: String
            
            public init(
                progress: CGFloat = 0.7,
                transformAngle: CGFloat = CGFloat(Double.pi * 2) * 0.7,
                transformX: CGFloat = .zero,
                transformY: CGFloat = .zero,
                transformZ: CGFloat = 1,
                endAnimationDuration: CGFloat = 0.5,
                startAnimationDuration: CGFloat = 0.4,
                endAnimationFillMode: CAMediaTimingFillMode = .forwards,
                startAnimationFillMode: CAMediaTimingFillMode = .forwards,
                pathAnimationFillMode: CAMediaTimingFillMode = .forwards,
                endAnimationBeginTime: CFTimeInterval = 0.1,
                startAnimationBeginTimeConstant: CFTimeInterval = 0.2,
                endRemovedOnCompletion: Bool = false,
                startRemovedOnCompletion: Bool = false,
                pathRemovedOnCompletion: Bool = false,
                startConstant: CGFloat = 0.05,
                mediaTimingFunction: CAMediaTimingFunction = .init(controlPoints: 0.39, 0.575, 0.565, 1.0),
                endAnimationKey: String = "strokeEnd",
                startAnimationKey: String = "strokeStart",
                animationKey: String = "stroke"
            ) {
                self.progress = progress
                self.transformAngle = transformAngle
                self.transformX = transformX
                self.transformY = transformY
                self.transformZ = transformZ
                self.endAnimationDuration = endAnimationDuration
                self.startAnimationDuration = startAnimationDuration
                self.endAnimationFillMode = endAnimationFillMode
                self.startAnimationFillMode = startAnimationFillMode
                self.pathAnimationFillMode = pathAnimationFillMode
                self.endAnimationBeginTime = endAnimationBeginTime
                self.startAnimationBeginTimeConstant = startAnimationBeginTimeConstant
                self.endRemovedOnCompletion = endRemovedOnCompletion
                self.startRemovedOnCompletion = startRemovedOnCompletion
                self.pathRemovedOnCompletion = pathRemovedOnCompletion
                self.startConstant = startConstant
                self.mediaTimingFunction = mediaTimingFunction
                self.endAnimationKey = endAnimationKey
                self.startAnimationKey = startAnimationKey
                self.animationKey = animationKey
            }
        }
        
        public init(
            frame: CGRect = .zero,
            backgroundColor: UIColor = .clear,
            containerInsets: UIEdgeInsets = .zero,
            circleLayer: CircleLayer = .init(),
            rotatingAnimation: RotatingAnimation = .init(),
            strokeAnimation: StrokeAnimation = .init()
        ) {
            self.frame = frame
            self.backgroundColor = backgroundColor
            self.containerInsets = containerInsets
            self.circleLayer = circleLayer
            self.rotatingAnimation = rotatingAnimation
            self.strokeAnimation = strokeAnimation
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    private lazy var circleShapeLayer = CAShapeLayer()
    private lazy var containerView = UIView()
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        removeSublayersAndConstraints()
        setupView(with: viewProperties)
        setupCircleLayer(with: viewProperties)
        startAnimating(with: viewProperties)
    }
    
    public func stopAnimating() {
        containerView.layer.transform = CATransform3DIdentity
        containerView.layer.removeAllAnimations()
        
        circleShapeLayer.transform = CATransform3DIdentity
        circleShapeLayer.removeAllAnimations()
    }
    
    // MARK: - Private methods
    
    private func setupView(with viewProperties: ViewProperties) {
        frame = viewProperties.frame
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(viewProperties.containerInsets)
            make.width.equalTo(viewProperties.frame.size.width)
            make.height.equalTo(viewProperties.frame.size.height)
        }
        containerView.frame = viewProperties.frame
        containerView.backgroundColor = viewProperties.backgroundColor
    }
    
    private func setupCircleLayer(with viewProperties: ViewProperties) {
        circleShapeLayer.path = UIBezierPath(
            arcCenter: center,
            radius: center.x,
            startAngle: viewProperties.circleLayer.startAngle,
            endAngle: viewProperties.circleLayer.endAngle,
            clockwise: viewProperties.circleLayer.clockwise
        ).cgPath
        circleShapeLayer.actions = viewProperties.circleLayer.actions
        circleShapeLayer.backgroundColor = viewProperties.circleLayer.backgroundColor.cgColor
        circleShapeLayer.strokeColor = viewProperties.circleLayer.strokeColor.cgColor
        circleShapeLayer.fillColor = viewProperties.circleLayer.fillColor.cgColor
        circleShapeLayer.lineWidth = viewProperties.circleLayer.lineWidth
        circleShapeLayer.lineCap = viewProperties.circleLayer.lineCap
        circleShapeLayer.strokeStart = viewProperties.circleLayer.strokeStart
        circleShapeLayer.strokeEnd = viewProperties.circleLayer.strokeEnd
        circleShapeLayer.frame = containerView.bounds
        
        containerView.layer.addSublayer(circleShapeLayer)
    }
    
    private func startAnimating(with viewProperties: ViewProperties) {
        if containerView.layer.animation(forKey: viewProperties.rotatingAnimation.animationKey) == nil {
            startStrokeAnimation(with: viewProperties)
            startRotatingAnimation(with: viewProperties)
        }
    }

    private func startRotatingAnimation(with viewProperties: ViewProperties) {
        containerView.layer.add(
            viewProperties.rotatingAnimation.animation,
            forKey: viewProperties.rotatingAnimation.animationKey
        )
    }
    
    private func startStrokeAnimation(with viewProperties: ViewProperties) {
        let endFromValue = circleShapeLayer.strokeEnd
        let endToValue = endFromValue + viewProperties.strokeAnimation.progress
        
        let endAnimation = makeEndAnimation(with: viewProperties)
        endAnimation.fromValue = endFromValue
        endAnimation.toValue = endToValue
        
        let startFromValue = circleShapeLayer.strokeStart
        let startToValue = abs(endToValue - viewProperties.strokeAnimation.startConstant)
        let startAnimation = makeStartAnimation(with: viewProperties)
        startAnimation.fromValue = startFromValue
        startAnimation.toValue = startToValue
        startAnimation.beginTime = endAnimation.beginTime 
            + endAnimation.duration
            + viewProperties.strokeAnimation.startAnimationBeginTimeConstant
        
        let pathAnimationGroup = makePathAnimationGroup(with: viewProperties)
        pathAnimationGroup.animations = [endAnimation, startAnimation]
        pathAnimationGroup.duration = startAnimation.beginTime + startAnimation.duration
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if self.circleShapeLayer.animation(forKey: viewProperties.strokeAnimation.animationKey) != nil {
                self.circleShapeLayer.transform = CATransform3DRotate(
                    self.circleShapeLayer.transform, 
                    viewProperties.strokeAnimation.transformAngle,
                    viewProperties.strokeAnimation.transformX,
                    viewProperties.strokeAnimation.transformY,
                    viewProperties.strokeAnimation.transformZ
                )
                self.circleShapeLayer.removeAnimation(forKey: viewProperties.strokeAnimation.animationKey)
                self.startStrokeAnimation(with: self.viewProperties)
            }
        }
        circleShapeLayer.add(pathAnimationGroup, forKey: viewProperties.strokeAnimation.animationKey)
        CATransaction.commit()
    }
    
    private func makeEndAnimation(with viewProperties: ViewProperties) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: viewProperties.strokeAnimation.endAnimationKey)
        animation.duration = viewProperties.strokeAnimation.endAnimationDuration
        animation.fillMode = viewProperties.strokeAnimation.endAnimationFillMode
        animation.timingFunction = viewProperties.strokeAnimation.mediaTimingFunction
        animation.beginTime = viewProperties.strokeAnimation.endAnimationBeginTime
        animation.isRemovedOnCompletion = viewProperties.strokeAnimation.endRemovedOnCompletion
        
        return animation
    }
    
    private func makeStartAnimation(with viewProperties: ViewProperties) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: viewProperties.strokeAnimation.startAnimationKey)
        animation.duration = viewProperties.strokeAnimation.startAnimationDuration
        animation.fillMode = viewProperties.strokeAnimation.startAnimationFillMode
        animation.timingFunction = viewProperties.strokeAnimation.mediaTimingFunction
        animation.isRemovedOnCompletion = viewProperties.strokeAnimation.startRemovedOnCompletion
        
        return animation
    }
    
    private func makePathAnimationGroup(with viewProperties: ViewProperties) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.fillMode = viewProperties.strokeAnimation.pathAnimationFillMode
        animationGroup.isRemovedOnCompletion = viewProperties.strokeAnimation.pathRemovedOnCompletion
        
        return animationGroup
    }

    private func removeSublayersAndConstraints() {
        containerView.snp.removeConstraints()
        containerView.removeFromSuperview()
        
        circleShapeLayer.transform = CATransform3DIdentity
    }
}
