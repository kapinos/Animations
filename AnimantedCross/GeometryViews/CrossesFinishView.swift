//
//  CrossesFinishView.swift
//  AnimantedCross
//
//  Created by Developer on 4/23/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class CrossesFinishView: GeometryShapeView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, shapeSize: CGFloat, color: UIColor, views: [[UIView]]?, angle: CGFloat) {
        super.init(frame: frame, shapeSize: shapeSize, color: color, views: views, angle: angle)
        
        createSubviews(from: views, with: color)
    }
}


// MARK: - GeometryShapesProtocol
extension CrossesFinishView: GeometryShapesProtocol {
    func createSubviews(from views: [[UIView]]?, with color: UIColor) {
        guard let views = views else { return }
        //let sizeMultiplier = (self.shapeSize / sqrt(2)) / (self.shapeSize * 2 / 3)

        // TODO: - add aditional rows and cols for crosses
        for line in views {
            var crossLine = [UIView]()
            for i in 0..<line.count {
                let point = CGPoint(x: line[i].frame.midX - self.shapeSize,
                                    y: line[i].frame.midY - self.shapeSize * CGFloat(max(1, 1)))
                
                let cross = UIView(frame: CGRect(origin: point,
                                                 size: CGSize(width: self.shapeSize, height: self.shapeSize)))
                cross.addCrossPathInViewsLayer(with: color)
                self.addSubview(cross)
                crossLine.append(cross)
            }
            shapesSubviews.append(crossLine)
        }
    }
    
    func animate(completion: @escaping () -> ()) {
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.calculationModeCubicPaced], animations: {
            for row in 0..<self.shapesSubviews.count {
                let rowShapes = self.shapesSubviews[row]
                for col in 0..<rowShapes.count {
                    let cross = rowShapes[col]
                    let step = cross.frame.size.width / 3
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                        cross.transform = CGAffineTransform(rotationAngle: self.angle.degreesToRadians())
                    })
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5, animations: {
                        cross.center = CGPoint(x: cross.frame.minX - CGFloat(row) * step,
                                               y: cross.frame.minY + CGFloat(col) * step)
                    })
                }
            }
        }) { (_) in completion() }
    }
}
