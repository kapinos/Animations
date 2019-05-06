//
//  CubesView.swift
//  AnimantedCross
//
//  Created by Anastasia on 4/23/19.
//  Copyright © 2019 Anastasia. All rights reserved.
//

import UIKit

class CubesView: GeometryShapeView {
        
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
extension CubesView: GeometryShapesProtocol {
    func createSubviews(from views: [[UIView]]?, with color: UIColor) {
        guard let views = views else { return }
        
        let step = self.shapeSize * 2 / 3
        
        for diagonal in views {
            var line = [UIView]()
            for i in 0..<diagonal.count {
                let point = CGPoint(x: diagonal[i].frame.minX + step, y: diagonal[i].frame.minY + step)
                let cube = UIView(frame: CGRect(origin: point, size: CGSize(width: step, height: step)))
                cube.backgroundColor = color
                self.addSubview(cube)
                line.append(cube)
            }
            self.shapesSubviews.append(line)
        }
    }
    
    func animate(completion: @escaping () -> ()) {
        let sizeMultiplier = (self.shapeSize / sqrt(2)) / (self.shapeSize * 2 / 3)
        
        UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: [.calculationModeCubic], animations: {
            for line in self.shapesSubviews {
                for cube in line {
                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                        cube.transform = CGAffineTransform(rotationAngle: self.angle.degreesToRadians())
                                        .scaledBy(x: sizeMultiplier, y: sizeMultiplier)
                    })
                }
            }
        }) { (_) in completion() }
    }
}
