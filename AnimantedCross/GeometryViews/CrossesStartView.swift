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
    
    override init(frame: CGRect, size: CGFloat, color: UIColor, angle: CGFloat) {
        super.init(frame: frame, size: size, color: color, angle: angle)
        
        cols = Int(self.bounds.width/size)
        rows = Int(self.bounds.height/size)
        
        createSubviews(from: nil, with: color)
    }
}


// MARK: - GeometryShapesProtocol
extension CrossesStartView: GeometryShapesProtocol {
    func createSubviews(from views: [[UIView]]?, with color: UIColor) {
        let step = self.size / 3
        
        let shift = countAdditional()
        
        for row in -shift.rows...rows {
            var diagonal = [UIView]()
            for col in 0...cols + shift.cols {
                let point = CGPoint(x: CGFloat(col)*size - CGFloat(row)*step,
                                    y: CGFloat(col)*step + CGFloat(row)*size)
                let cross = UIView(frame: CGRect(origin: point, size: CGSize(width: size, height: size)))
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
                    { cross.center = CGPoint(x: CGFloat(i)*self.size, y: lastCross.frame.minY) }
                }
            }
        }) { (_) in completion() }
    }
}


// MARK: - Private
private extension CrossesStartView {
    func countAdditional() -> (rows: Int, cols: Int) {
        let step = self.size / 3
        
        let lastCrossInFirstLine = CGPoint(x: CGFloat(cols)*size - 0*step,
                                           y: CGFloat(cols)*step + 0*size)
        
        let additionalRows = lastCrossInFirstLine.y / (size*2/3)
        
        let lastCrossInLastLine = CGPoint(x: CGFloat(cols)*size - CGFloat(rows)*step,
                                          y: CGFloat(cols)*step + CGFloat(rows)*size)
        let additionalCols = (lastCrossInLastLine.x + size) / (size*2/3)
        
        return (Int(additionalRows.rounded()), Int(additionalCols.rounded()))
    }
}


extension UIView {
    func addCrossPathInViewsLayer(with color: UIColor) {
        let step = self.bounds.width / 3

        let k: CGFloat = step - (self.bounds.width / sqrt(2)) / 2

        let path = UIBezierPath()
        let start = CGPoint(x: step - k, y: 0)

        path.move(to: start)

        path.addLine(to: CGPoint(x: step * 2 + k, y: step * 0))
        path.addLine(to: CGPoint(x: step * 2 + k, y: step * 1 - k ))
        path.addLine(to: CGPoint(x: step * 3, y: step * 1 - k))
        path.addLine(to: CGPoint(x: step * 3, y: step * 2 + k))
        path.addLine(to: CGPoint(x: step * 2 + k, y: step * 2 + k ))
        path.addLine(to: CGPoint(x: step * 2 + k , y: step * 3))
        path.addLine(to: CGPoint(x: step * 1 - k, y: step * 3))
        path.addLine(to: CGPoint(x: step * 1 - k, y: step * 2 + k))
        path.addLine(to: CGPoint(x: step * 0, y: step * 2 + k))
        path.addLine(to: CGPoint(x: step * 0, y: step * 1 - k))
        path.addLine(to: CGPoint(x: step * 1 - k, y: step * 1 - k))

        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor

        self.layer.addSublayer(shapeLayer)
    }
}
