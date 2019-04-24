//
//  UIView+Extension.swift
//  AnimantedCross
//
//  Created by Developer on 4/24/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

extension UIView {
    func addCrossPathInViewsLayer(with color: UIColor) {
        let step = self.bounds.width / 3
        
        // let k: CGFloat = step - (self.bounds.width / sqrt(2)) / 2
        let k: CGFloat = 0
        
        let path = UIBezierPath()
        let start = CGPoint(x: step - k, y: 0)
        
        path.move(to: start)
        
        path.addLine(to: CGPoint(x: step * 2 + k,   y: step * 0))
        path.addLine(to: CGPoint(x: step * 2 + k,   y: step * 1 - k ))
        path.addLine(to: CGPoint(x: step * 3,       y: step * 1 - k))
        path.addLine(to: CGPoint(x: step * 3,       y: step * 2 + k))
        path.addLine(to: CGPoint(x: step * 2 + k,   y: step * 2 + k ))
        path.addLine(to: CGPoint(x: step * 2 + k,   y: step * 3))
        path.addLine(to: CGPoint(x: step * 1 - k,   y: step * 3))
        path.addLine(to: CGPoint(x: step * 1 - k,   y: step * 2 + k))
        path.addLine(to: CGPoint(x: step * 0,       y: step * 2 + k))
        path.addLine(to: CGPoint(x: step * 0,       y: step * 1 - k))
        path.addLine(to: CGPoint(x: step * 1 - k,   y: step * 1 - k))
        
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
    
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
