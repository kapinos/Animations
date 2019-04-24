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
    
    override init(frame: CGRect, size: CGFloat, color: UIColor, views: [[UIView]]?, angle: CGFloat) {
        super.init(frame: frame, size: size, color: color, views: views, angle: angle)
        
        createSubviews(from: views, with: color)
    }
}


extension CrossesFinishView: GeometryShapesProtocol {
    func createSubviews(from views: [[UIView]]?, with color: UIColor) {
        guard let views = views else { return }
        
        for line in views{
            var crossLine = [UIView]()
            for i in 0..<line.count {
                let view = line[i]
                let point = CGPoint(x: view.frame.midX, y: view.frame.midY)
                
                let cross = UIView(frame: CGRect(origin: point, size: CGSize(width: self.size, height: self.size)))
                cross.addCrossPathInViewsLayer(with: color)
                self.addSubview(cross)
                crossLine.append(cross)
            }
            shapesSubviews.append(crossLine)
        }
    }
    
    func animate(completion: @escaping () -> ()) {
        UIView.animateKeyframes(withDuration: 1.2, delay: 0.2, options: [.calculationModeCubicPaced], animations: {
            for diagonal in self.shapesSubviews {
                
                guard let lastCross = diagonal.last else { return }
                for i in 0..<diagonal.count {
                    let cross = diagonal[i]
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25)
                    { cross.transform = CGAffineTransform(rotationAngle: self.angle.degreesToRadians()) }

                    // TODO: - move not to lines - in diagonales
                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5)
                    { cross.center = CGPoint(x: CGFloat(i)*self.size, y: lastCross.frame.minY) }
                }
            }
        }) { (_) in completion() }
    }
}
