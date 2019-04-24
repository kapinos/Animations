//
//  CrossesStartView.swift
//  AnimantedCross
//
//  Created by Developer on 4/23/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class CrossesStartView: GeometryShapeView {

    // MARK: - Properties
    private var cols = 0
    private var rows = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, shapeSize: CGFloat, color: UIColor, angle: CGFloat) {
//        let additional = shapeSize * CGFloat(10)
//        let scaledFrame = CGRect(origin: CGPoint(x: -additional, y: -additional),
//                                 size: CGSize(width: frame.width + additional * 2, height: frame.height + add))
        
        super.init(frame: frame, shapeSize: shapeSize, color: color, angle: angle)
        
        cols = Int(self.bounds.width/shapeSize)
        rows = Int(self.bounds.height/shapeSize)
        
        createSubviews(from: nil, with: color)
    }
}


// MARK: - GeometryShapesProtocol
extension CrossesStartView: GeometryShapesProtocol {
    func createSubviews(from views: [[UIView]]?, with color: UIColor) {
        let step = self.shapeSize / 3
        
        let shift = countAdditional()
        
        for row in -shift.rows...rows {
            var diagonal = [UIView]()
            for col in 0...cols + shift.cols {
                let point = CGPoint(x: CGFloat(col)*shapeSize - CGFloat(row)*step,
                                    y: CGFloat(col)*step + CGFloat(row)*shapeSize)
                let cross = UIView(frame: CGRect(origin: point, size: CGSize(width: shapeSize, height: shapeSize)))
                cross.addCrossPathInViewsLayer(with: color)
                self.addSubview(cross)
                diagonal.append(cross)
            }
            shapesSubviews.append(diagonal)
        }
    }
    
    func animate(completion: @escaping ()->()) {
        UIView.animateKeyframes(withDuration: 1, delay: 0.6, options: [.calculationModeCubicPaced], animations: {
            for diagonal in self.shapesSubviews {
                
                guard let lastCross = diagonal.last else { return }
                for i in 0..<diagonal.count {
                    let cross = diagonal[i]
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25)
                    { cross.transform = CGAffineTransform(rotationAngle: self.angle.degreesToRadians()) }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5)
                    { cross.center = CGPoint(x: CGFloat(i)*self.shapeSize, y: lastCross.frame.minY) }
                }
            }
        }) { (_) in completion() }
    }
}


// MARK: - Private
private extension CrossesStartView {
    func countAdditional() -> (rows: Int, cols: Int) {
        let step = self.shapeSize / 3
        
        let lastCrossInFirstLine = CGPoint(x: CGFloat(cols)*shapeSize - 0*step,
                                           y: CGFloat(cols)*step      + 0*shapeSize)
        
        let additionalRows = lastCrossInFirstLine.y / (shapeSize*2/3)
        
        let lastCrossInLastLine = CGPoint(x: CGFloat(cols)*shapeSize - CGFloat(rows)*step,
                                          y: CGFloat(cols)*step      + CGFloat(rows)*shapeSize)
        let additionalCols = (lastCrossInLastLine.x + shapeSize) / (shapeSize*2/3)
        
        return (Int(additionalRows.rounded()), Int(additionalCols.rounded()))
    }
}
