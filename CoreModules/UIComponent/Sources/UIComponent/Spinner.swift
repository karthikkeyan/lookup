import Foundation
import SwiftUI
import UIKit

public struct Spinner: UIViewRepresentable {
    public class Coordinator {
        fileprivate let view: CircularSpinner

        public init(view: CircularSpinner) {
            self.view = view
        }
    }

    private let isAnimating: Bool

    public init(isAnimating: Bool) {
        self.isAnimating = isAnimating
    }

    public func makeCoordinator() -> Coordinator {
        let view = CircularSpinner()
        view.circleLayer.strokeColor = UIColor.orange.cgColor
        view.circleLayer.lineWidth = 3
        return Coordinator(view: view)
    }

    public func makeUIView(context: Context) -> some UIView {
        context.coordinator.view
    }

    public func updateUIView(_: UIViewType, context: Context) {
        if isAnimating {
            if !context.coordinator.view.isAnimating {
                context.coordinator.view.beginRefreshing()
            }
        } else {
            if context.coordinator.view.isAnimating {
                context.coordinator.view.endRefreshing()
            }
        }
    }
}

// MARK: - SpinnerUIView - UIView

open class CircularSpinner: UIView {
    public let circleLayer = CAShapeLayer()
    open private(set) var isAnimating = false
    open var animationDuration: TimeInterval = 2.0

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {
        layer.addSublayer(circleLayer)

        circleLayer.fillColor = nil
        circleLayer.lineWidth = 1.5

        circleLayer.strokeColor = UIColor.orange.cgColor
        circleLayer.strokeStart = 0
        circleLayer.strokeEnd = 0

        circleLayer.lineCap = .round
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        if circleLayer.frame != bounds {
            updateCircleLayer()
        }
    }

    open func updateCircleLayer() {
        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let radius = (bounds.height - circleLayer.lineWidth) / 2.0

        let startAngle: CGFloat = 0.0
        let endAngle: CGFloat = 2.0 * CGFloat.pi

        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        circleLayer.path = path.cgPath
        circleLayer.frame = bounds
    }

    open func forceBeginRefreshing() {
        isAnimating = false
        beginRefreshing()
    }

    open func beginRefreshing() {
        if isAnimating {
            return
        }

        isAnimating = true

        let rotateAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotateAnimation.values = [
            0.0,
            Float.pi,
            2.0 * Float.pi,
        ]

        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.duration = (animationDuration / 2.0)
        headAnimation.fromValue = 0
        headAnimation.toValue = 0.25

        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.duration = (animationDuration / 2.0)
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1

        let endHeadAnimation = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnimation.beginTime = (animationDuration / 2.0)
        endHeadAnimation.duration = (animationDuration / 2.0)
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1

        let endTailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnimation.beginTime = (animationDuration / 2.0)
        endTailAnimation.duration = (animationDuration / 2.0)
        endTailAnimation.fromValue = 1
        endTailAnimation.toValue = 1

        let animations = CAAnimationGroup()
        animations.duration = animationDuration
        animations.animations = [
            rotateAnimation,
            headAnimation,
            tailAnimation,
            endHeadAnimation,
            endTailAnimation,
        ]
        animations.repeatCount = Float.infinity
        animations.isRemovedOnCompletion = false

        circleLayer.add(animations, forKey: "animations")
    }

    open func endRefreshing() {
        isAnimating = false
        circleLayer.removeAnimation(forKey: "animations")
    }
}
