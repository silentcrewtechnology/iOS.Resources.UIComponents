import UIKit

public final class LoaderAnimationLayer: CAShapeLayer, ComponentProtocol {
    
    public struct ViewProperties {
        public var frame: CGRect
        public var strokeColor: CGColor
        public var lineWidth: CGFloat
        public var animation: LoaderAnimation?
        
        public init(
            frame: CGRect = .zero,
            strokeColor: CGColor = UIColor.tintColor.cgColor,
            lineWidth: CGFloat = 1,
            animation: LoaderAnimation? = nil
        ) {
            self.frame = frame
            self.strokeColor = strokeColor
            self.lineWidth = lineWidth
            self.animation = animation
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public func update(with viewProperties: ViewProperties) {
        updateBezierPath(with: viewProperties)
        strokeColor = viewProperties.strokeColor
        fillColor = UIColor.clear.cgColor
        lineWidth = viewProperties.lineWidth
        lineCap = .round
        updateAnimation(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateBezierPath(with viewProperties: ViewProperties) {
        let pathFrame = viewProperties.frame
        let center = CGPoint(x: pathFrame.midX, y: pathFrame.midY)
        frame = pathFrame
        path = UIBezierPath(
            arcCenter: center,
            radius: center.x,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        ).cgPath
    }
    
    private func updateAnimation(with viewProperties: ViewProperties) {
        if let animation = viewProperties.animation {
            startAnimating(with: animation)
        } else {
            stopAnimating()
        }
    }
    
    private func startAnimating(with animation: CAAnimation) {
        guard self.animation(forKey: "loading") == nil else { return }
        add(animation, forKey: "loading")
    }
    
    private func stopAnimating() {
        removeAllAnimations()
    }
}
