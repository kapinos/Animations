//
//  ViewController.swift
//  AnimantedCross
//
//  Created by Anastasia Kapinos on 4/9/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

// FIXME: - need to
// - create class for CrossView
// - customize animation blocks - set in different functions

class ViewController: UIViewController {
    
    // MARK: - Properties
    var crossesInDiagonales = [[UIView]]()
    var cubesInLines = [[UIView]]()
    
    let size: CGFloat = 30
    
    let crossesColor = UIColor.yellow
    let bgColor = UIColor.black
    
    var cols = 0
    var rows = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = bgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cols = Int(self.view.bounds.width/size)
        rows = Int(self.view.bounds.height/size)
        
        restoreView()
        
        
        createDiagonalsWithCrosses()
        self.animateByDiagonalsToRows(completion: {
            self.invertCrossesAndCubes()
            self.animateCubesToRombs()
        })
    }
}

// MARK: - Creation Views for Animations
private extension ViewController {
    func createDiagonalsWithCrosses() {
        let step = self.size / 3
        
        let shift = countAdditional()

        for row in -shift.rows...rows {
            var diagonal = [UIView]()
            for col in 0...cols + shift.cols {
                let point = CGPoint(x: CGFloat(col)*size - CGFloat(row)*step,
                                    y: CGFloat(col)*step + CGFloat(row)*size)
                let cross = UIView(frame: CGRect(origin: point, size: CGSize(width: size, height: size)))
                cross.addCrossPathInViewsLayer(with: crossesColor)
                self.view.addSubview(cross)
                diagonal.append(cross)
            }
            crossesInDiagonales.append(diagonal)
        }
    }
    
    func createRowsWithCubes() {
        let step = self.size / 3
        
        for diagonal in crossesInDiagonales {
            var line = [UIView]()
            for i in 0..<diagonal.count {
                let point = CGPoint(x: diagonal[i].frame.minX + step*2, y: diagonal[i].frame.minY + step*2)
                let cube = UIView(frame: CGRect(origin: point, size: CGSize(width: step*2, height: step*2)))
                cube.backgroundColor = self.bgColor
                self.view.addSubview(cube)
                line.append(cube)
            }
            cubesInLines.append(line)
        }
    }

    // (1) hide diagonalster
    // (2) change BG
    // (3) display cubes
    func invertCrossesAndCubes() {
        self.view.backgroundColor = self.crossesColor
        self.createRowsWithCubes()
        self.crossesInDiagonales.flatMap{ $0.map{ $0.isHidden = true } }
    }
    
    func restoreView() {
        _ = self.view.subviews.map{ $0.removeFromSuperview() }
        self.view.backgroundColor = self.bgColor
    }
}

// MARK: - Animations
private extension ViewController {
    // MARK: - First Step
    func animateByDiagonalsToRows(completion: @escaping ()->()) {
        for diagonal in crossesInDiagonales {
            
            guard let lastCross = diagonal.last else { return }
            for i in 0..<diagonal.count {
                let cross = diagonal[i]
                
                UIView.animateKeyframes(withDuration: 1,
                                        delay: 1,
                                        options: [.calculationModeCubicPaced],
                                        animations:
                    {
                    // UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                    //  cross.layer.transform = CATransform3DMakeRotation(self.degreesToRadians(-180), 10, 10, 0)
                    // }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                        cross.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(-90))
                    }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5) {
                        cross.center = CGPoint(x: CGFloat(i)*self.size, y: lastCross.frame.minY)
                    }
                }) { (_) in
                    if i == diagonal.count-1 {
                        completion()
                    }
                }
            }
        }
    }
    
    // MARK: - Second Step
    func animateCubesToRombs() {
        for line in cubesInLines {
            for i in 0..<line.count {
                let cube = line[i]
                
                UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubicPaced], animations: {
                    cube.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(135))
                }) { (_) in
                    
                }
            }
        }
    }
}



// MARK: - Private Helpers
private extension ViewController {
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
    func addCrossPathInViewsLayer(with color: UIColor) {
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
        shapeLayer.fillColor = color.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
}
