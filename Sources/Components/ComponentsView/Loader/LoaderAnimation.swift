import UIKit

/// Настраиваемая анимация лоадера
public final class LoaderAnimation: CAAnimationGroup {
    
    public struct ViewProperties {
        /// Длина одной итерации
        public var duration: CFTimeInterval
        /// Сделать меньше `1` для замедления анимации
        public var speedMultiplier: Float
        /// Минимальная длина дуги
        public var minArcLength: CGFloat
        /// Максимальная длина дуги
        public var maxArcLength: CGFloat
        /// Угол поворота за 1 итерацию
        public var rotationAngle: CGFloat
        
        public init(
            duration: CFTimeInterval = 1.4,
            speedMultiplier: Float = 1,
            minArcLength: CGFloat = 15 / 360,
            maxArcLength: CGFloat = 270 / 360,
            rotationAngle: CGFloat = .pi * 2 * (2 - 270 / 360)
        ) {
            self.duration = duration
            self.speedMultiplier = speedMultiplier
            self.minArcLength = minArcLength
            self.maxArcLength = maxArcLength
            self.rotationAngle = rotationAngle
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public override init() { super.init() }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        animations = [
            makeResetAnimation(with: viewProperties),
            makeRotationAnimation(with: viewProperties),
            makeStrokeAnimation(with: viewProperties),
        ]
        duration = viewProperties.duration
        repeatCount = .infinity
        speed = viewProperties.speedMultiplier
        isRemovedOnCompletion = false // чтобы крутилось всегда
        self.viewProperties = viewProperties
    }
    
    // MARK: Private methods
    
    /// Псевдоанимация сброса заполненной области
    private func makeResetAnimation(
        with viewProperties: ViewProperties
    ) -> CAAnimation {
        let group = CAAnimationGroup()
        let resetStrokeStartAnimation: CABasicAnimation = {
            let animation = makeDefaultStrokeStartAnimation()
            animation.toValue = 0
            return animation
        }()
        let resetStrokeEndAnimation: CABasicAnimation = {
            let animation = makeDefaultStrokeEndAnimation()
            animation.toValue = viewProperties.minArcLength
            return animation
        }()
        group.animations = [
            resetStrokeStartAnimation,
            resetStrokeEndAnimation,
        ]
        group.duration = 0
        return group
    }
    
    /// Анимация поворота
    private func makeRotationAnimation(
        with viewProperties: ViewProperties
    ) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.beginTime = 0
        animation.fromValue = 0
        animation.duration = viewProperties.duration
        animation.toValue = viewProperties.rotationAngle
        animation.timingFunction = .init(name: .linear)
        return animation
    }
    
    /// Анимация заполненной области
    private func makeStrokeAnimation(
        with viewProperties: ViewProperties
    ) -> CAAnimation {
        let group = CAAnimationGroup()
        let leadingFirstHalfAnimation: CABasicAnimation = {
            let animation = makeDefaultStrokeEndAnimation()
            animation.fromValue = viewProperties.minArcLength
            animation.duration = viewProperties.duration / 2
            animation.toValue = viewProperties.maxArcLength + viewProperties.minArcLength
            animation.timingFunction = .init(name: .easeInEaseOut)
            return animation
        }()
        let trailingSecondHalfAnimation: CABasicAnimation = {
            let animation = makeDefaultStrokeStartAnimation()
            animation.beginTime = viewProperties.duration / 2
            animation.duration = viewProperties.duration / 2
            animation.toValue = viewProperties.maxArcLength
            animation.timingFunction = .init(name: .easeInEaseOut)
            return animation
        }()
        group.animations = [
            leadingFirstHalfAnimation,
            trailingSecondHalfAnimation,
        ]
        return group
    }
    
    private func makeDefaultStrokeStartAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fillMode = .forwards // чтобы дуга оставалась на экране при зацикливании
        return animation
    }
    
    private func makeDefaultStrokeEndAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fillMode = .forwards // чтобы дуга оставалась на экране при зацикливании
        return animation
    }
}
