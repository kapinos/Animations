//
//  ViewController.swift
//  AnimantedCross
//
//  Created by Developer on 4/9/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: - Properties
    var crossesDiagonales = [[UIView]]()
    let size: CGFloat = 30
    var isAnimation = true
    
    var cols = 0
    var rows = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cols = Int(self.view.bounds.width/size)
        rows = Int(self.view.bounds.height/size)
        
        _ = self.view.subviews.map{ $0.removeFromSuperview() }
        
        createDiagonals()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute:  {
            self.animateByDiagonal()
        })
    }
}

extension ViewController {
    func createDiagonals() {
        let step = self.size / 3
        
        let shift = countAdditional()

        for row in -shift.rows...rows {
            var diagonal = [UIView]()
            for col in 0...cols + shift.cols {
                let point = CGPoint(x: CGFloat(col)*size - CGFloat(row)*step,
                                    y: CGFloat(col)*step + CGFloat(row)*size)
                let cross = UIView(frame: CGRect(origin: point, size: CGSize(width: size, height: size)))
                cross.createCross()
                self.view.addSubview(cross)
                diagonal.append(cross)
            }
            crossesDiagonales.append(diagonal)
        }
    }
    
    func animateByDiagonal() {
        for diagonal in crossesDiagonales {
            
            guard let lastCross = diagonal.last else { return }
            for i in 0..<diagonal.count {
                let cross = diagonal[i]
                
                UIView.animateKeyframes(withDuration: 2,
                                        delay: 0,
                                        options: [.calculationModeCubicPaced],
                                        animations:
                    {
//                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
//                            cross.layer.transform = CATransform3DMakeRotation(self.degreesToRadians(-180), 10, 10, 0)
//                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                            cross.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(-90))
                        }
                        
                        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                            cross.center = CGPoint(x: CGFloat(i)*self.size,
                                                   y: lastCross.frame.minY)
                        }
                })
            }
        }
    }
    
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
    
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
    func createCross() {
        let step = self.bounds.width / 3
        
        let path = UIBezierPath()
        let start = CGPoint(x: step, y: 0)
        
        path.move(to: start)
        
        path.addLine(to: CGPoint(x: step * 2, y: step * 0))
        path.addLine(to: CGPoint(x: step * 2, y: step * 1))
        path.addLine(to: CGPoint(x: step * 3, y: step * 1))
        path.addLine(to: CGPoint(x: step * 3, y: step * 2))
        path.addLine(to: CGPoint(x: step * 2, y: step * 2))
        path.addLine(to: CGPoint(x: step * 2, y: step * 3))
        path.addLine(to: CGPoint(x: step * 1, y: step * 3))
        path.addLine(to: CGPoint(x: step * 1, y: step * 2))
        path.addLine(to: CGPoint(x: step * 0, y: step * 2))
        path.addLine(to: CGPoint(x: step * 0, y: step * 1))
        path.addLine(to: CGPoint(x: step * 1, y: step * 1))

        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.yellow.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
}
