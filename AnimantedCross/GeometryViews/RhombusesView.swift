//
//  RhombusesView.swift
//  AnimantedCross
//
//  Created by Developer on 4/23/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

// FIXME:
// - count how to draw rhombus path in subview with same path like was bg
// - count how to add extra column on the left side

class RhombusesView: GeometryShapeView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, size: CGFloat, color: UIColor, views: [[UIView]]?, angle: CGFloat) {
        super.init(frame: frame, size: size, color: color, views: views, angle: angle)
        
        createSubviews(from: views, with: color)
    }
}


// MARK: - GeometryShapesProtocol
extension RhombusesView: GeometryShapesProtocol {
    func createSubviews(from views: [[UIView]]?, with color: UIColor) {
        guard let views = views else { return }

        for line in views {
            var rLine = [UIView]()
            for i in 0..<line.count {
                let viewSize = line[i].frame.size

                // TODO: - count normally - adding exta column at the left side ◆
                // FIXME: - 2 ➢ stub
//                if i == 0 {
//                    let point = CGPoint(x: line[i].frame.midX - viewSize.width - 2, y: line[i].frame.midY)
//                    let rhombus = UIView(frame: CGRect(origin: point, size: viewSize))
//                    rhombus.addRhombusPathInViewsLayer(with: color)
//                    self.addSubview(rhombus)
//                    rLine.append(rhombus)
//                }
                ///

                let point = CGPoint(x: line[i].frame.midX, y: line[i].frame.midY)
                let rhombus = UIView(frame: CGRect(origin: point, size: viewSize))
                rhombus.addRhombusPathInViewsLayer(with: color)
                self.addSubview(rhombus)
                rLine.append(rhombus)
            }
            shapesSubviews.append(rLine)
        }
    }
    
    func animate(completion: @escaping () -> ()) {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubicPaced], animations: {
            for line in self.shapesSubviews {
                for rhoumbus in line {
                    rhoumbus.transform = CGAffineTransform(rotationAngle: self.angle.degreesToRadians())
                    print(">>> rhoumbus.originalFrame(): ", rhoumbus.originalFrame())
                }
            }
        }) { (_) in completion() }
    }
}

extension UIView {
    // These four methods return the positions of view elements
    // with respect to the current transform
    func transformedTopLeft() -> CGPoint {
        let frame = self.originalFrame
        let point = frame().origin
        return self.pointInTransformedView(aPoint: point)
    }
    
    func transformedTopRight() -> CGPoint {
        let frame = self.originalFrame
        var point = frame().origin
        point.x += frame().size.width
        return self.pointInTransformedView(aPoint: point)
    }
    
    func transformedBottomRight() -> CGPoint {
        let frame = self.originalFrame
        var point = frame().origin
        point.x += frame().size.width
        point.y += frame().size.height
        return self.pointInTransformedView(aPoint: point)
    }
    
    func transformedBottomLeft() -> CGPoint {
        let frame = self.originalFrame
        var point = frame().origin
        point.y += frame().size.height
        return self.pointInTransformedView(aPoint: point)
    }
    
    // Coordinate utilities
    func offsetPointToParentCoordinates(aPoint: CGPoint) -> CGPoint {
        return CGPoint(x: aPoint.x + self.center.x,
                       y: aPoint.y + self.center.y)
    }
    
    func pointInViewCenterTerms(aPoint: CGPoint) -> CGPoint {
        return CGPoint(x: aPoint.x - self.center.x,
                       y: aPoint.y - self.center.y)
    }
    
    func pointInTransformedView(aPoint: CGPoint) -> CGPoint {
        let offsetItem = self.pointInViewCenterTerms(aPoint: aPoint)
        let updatedItem = offsetItem.applying(self.transform)
        let finalItem = self.offsetPointToParentCoordinates(aPoint: updatedItem)
        return finalItem
    }
    
    func originalFrame() -> CGRect {
        let currentTransform = self.transform
        self.transform = CGAffineTransform.identity
        let originalFrame = self.frame
        self.transform = currentTransform
        
        return originalFrame
    }
}


extension UIView {
    func addRhombusPathInViewsLayer(with color: UIColor) {
        let step = self.bounds.width / 2

        let path = UIBezierPath()
        let startPoint = CGPoint(x: step, y: 0)

        path.move(to: startPoint)
        // let secPoint = CGPoint(x: step * 2, y: step * 1)
        // print(">>> dist: ", CGPointDistance(from: start, to: secPoint)) // 20
        path.addLine(to: CGPoint(x: step * 2, y: step * 1))
        path.addLine(to: CGPoint(x: step * 1, y: step * 2))
        path.addLine(to: CGPoint(x: step * 0, y: step * 1))
        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.backgroundColor = UIColor.GeometryColors.opposite(color: color).cgColor

        self.layer.addSublayer(shapeLayer)
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
}


