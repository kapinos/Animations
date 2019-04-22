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
    
    // TODO: - need to create separated views for geomerty elements
    var crossesInDiagonales = [[UIView]]()
    var cubesInLines = [[UIView]]()
    var rhombusesInLines = [[UIView]]()
    
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
            self.invertCrossesToCubes()
            self.animateCubesToRhombuses(completion: {
                self.invertCubesToRhombuses()
                self.animateRhombusesToLines { }
            })
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
    
    func createRowsWithRhombus() {
        for line in cubesInLines {
            var rLine = [UIView]()
            for i in 0..<line.count {
                let viewSize = line[i].frame.size
                // TODO: - extend in separated method
                if i == 0 {
                    let point = CGPoint(x: line[i].frame.midX - viewSize.width, y: line[i].frame.midY)
                    let rhombus = UIView(frame: CGRect(origin: point, size: viewSize))
                    rhombus.addRhombusPathInViewsLayer(with: self.crossesColor, bg: self.bgColor)
                    self.view.addSubview(rhombus)
                    rLine.append(rhombus)
                }

                let point = CGPoint(x: line[i].frame.midX, y: line[i].frame.midY)
                let rhombus = UIView(frame: CGRect(origin: point, size: viewSize))
                rhombus.addRhombusPathInViewsLayer(with: self.crossesColor, bg: self.bgColor)
                self.view.addSubview(rhombus)
                rLine.append(rhombus)
            }
            rhombusesInLines.append(rLine)
        }
    }

    func invertCrossesToCubes() {
        self.view.backgroundColor = self.crossesColor
        self.createRowsWithCubes()
        _ = self.crossesInDiagonales.flatMap{ $0.map{ $0.isHidden = true } }
    }
    
    func invertCubesToRhombuses() {
        self.view.backgroundColor = self.bgColor
        self.createRowsWithRhombus()
        _ = self.cubesInLines.flatMap{ $0.map{ $0.removeFromSuperview() } }
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
        
        UIView.animateKeyframes(withDuration: 1, delay: 1, options: [.calculationModeCubicPaced], animations: {
            for diagonal in self.crossesInDiagonales {
                
                guard let lastCross = diagonal.last else { return }
                for i in 0..<diagonal.count {
                    let cross = diagonal[i]
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25)
                    { cross.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(-90)) }
                    
                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.5)
                    { cross.center = CGPoint(x: CGFloat(i)*self.size, y: lastCross.frame.minY) }
                }
            }
        }) { (_) in completion() }
    }
    
    // MARK: - Second Step
    func animateCubesToRhombuses(completion: @escaping ()->()) {
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubicPaced], animations: {
            for line in self.cubesInLines {
                for cube in line {
                    cube.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(135))
                    cube.layer.shouldRasterize = true
                }
            }
        }) { (_) in completion() }
    }
    
    
    // MARK: - Third Step
    func animateRhombusesToLines(completion: @escaping ()->()) {
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [.calculationModeCubicPaced], animations: {
            for line in self.rhombusesInLines {
                for rhoumbus in line {
                    rhoumbus.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(-135))
                }
            }
        }) { (_) in completion() }
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


// MARK: - will be moved to separated view with crosses
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
    
    func addRhombusPathInViewsLayer(with color: UIColor, bg: UIColor) {
        let step = self.bounds.width / 2
        
        let path = UIBezierPath()
        let startPoint = CGPoint(x: step, y: 0)
        
        path.move(to: startPoint)
//        let secPoint = CGPoint(x: step * 2, y: step * 1)
//        print(">>> dist: ", CGPointDistance(from: start, to: secPoint)) // 20
        path.addLine(to: CGPoint(x: step * 2, y: step * 1))
        path.addLine(to: CGPoint(x: step * 1, y: step * 2))
        path.addLine(to: CGPoint(x: step * 0, y: step * 1))
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
        shapeLayer.backgroundColor = bg.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
}


// MARK: - Helpers
extension ViewController {
    func printStartTime(_ functionName: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "mm:ss"
        
        let dateString = formatter.string(from: Date())
        print(">>> func: \(functionName): ", dateString)
    }
}
