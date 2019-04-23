//
//  CubesView.swift
//  AnimantedCross
//
//  Created by Developer on 4/23/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class CubesView: GeometryShapeView {
        
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
extension CubesView: GeometryShapesProtocol {
    func createSubviews(from views: [[UIView]]?, with color: UIColor) {
        guard let views = views else { return }
        
        let step = self.size / 3
        
        for diagonal in views {
            var line = [UIView]()
            for i in 0..<diagonal.count {
                let point = CGPoint(x: diagonal[i].frame.minX + step * 2, y: diagonal[i].frame.minY + step * 2)
                let cube = UIView(frame: CGRect(origin: point, size: CGSize(width: step * 2, height: step * 2)))
                cube.backgroundColor = color
                self.addSubview(cube)
                line.append(cube)
            }
            self.shapesSubviews.append(line)
        }
    }
    
    func animate(completion: @escaping () -> ()) {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubicPaced], animations: {
            for line in self.shapesSubviews {
                for cube in line {
                    cube.transform = CGAffineTransform(rotationAngle: self.angle.degreesToRadians())
                }
            }
        }) { (_) in completion() }
    }
}
