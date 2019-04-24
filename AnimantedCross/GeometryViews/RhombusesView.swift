//
//  RhombusesView.swift
//  AnimantedCross
//
//  Created by Developer on 4/23/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

// FIXME:
// - count how to add extra column on the left side

class RhombusesView: GeometryShapeView {
        
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
extension RhombusesView: GeometryShapesProtocol {
    func createSubviews(from views: [[UIView]]?, with color: UIColor) {
        guard let views = views else { return }

        for line in views {
            var rLine = [UIView]()
            for i in 0..<line.count {
                let point = CGPoint(x: line[i].frame.midX - self.shapeSize, y: line[i].frame.midY - self.shapeSize)
                let rhombus = UIView(frame: CGRect(origin: point,
                                                   size:   CGSize(width: self.shapeSize, height: self.shapeSize)))
                rhombus.addRhombusPathInViewsLayer(with: color)
                self.addSubview(rhombus)
                rLine.append(rhombus)
            }
            shapesSubviews.append(rLine)
        }
    }
    
    func animate(completion: @escaping () -> ()) {
        let sizeMultiplier = (self.shapeSize*2/3) / (self.shapeSize/sqrt(2))

        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: [.calculationModeCubicPaced], animations: {
            for line in self.shapesSubviews {
                for rhoumbus in line {
                    rhoumbus.transform = CGAffineTransform(rotationAngle: self.angle.degreesToRadians())
                                        .scaledBy(x: sizeMultiplier, y: sizeMultiplier)
                }
            }
        }) { (_) in completion() }
    }
}
