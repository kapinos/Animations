//
//  ViewController.swift
//  AnimantedCross
//
//  Created by Developer on 4/9/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var animateButton: UIButton!
    
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
        
        createDiagonals()
        
        animateByDiagonal()
    }
    
    @IBAction func animateButtonPressed(_ sender: UIButton) {
        animate()
    }
}

extension ViewController {
    func createDiagonals() {
        let step = self.size / 3
        
        let partial = Int(self.size*2/3)
        
        // TODO: - calculate shift right/left/up/down out of the screen bounds instead of -rows..<rows*2
        for row in -rows...rows {
            var diagonal = [UIView]()
            for col in -1...cols*2 {
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
            for cross in diagonal {
                print(">>> currentPosition: ", cross.frame.minX, ", ", cross.frame.minY)
            }
        }
    }

    func animate() {
        let shift: CGFloat = 10
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubicPaced, animations: {
            let angle: CGFloat = self.isAnimation ? -90 : 90
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
               // _ = self.crosses.map{ $0.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(angle)) }
            }
            
            let shiftDown = self.isAnimation ? shift : -shift
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                //_ = self.crosses.map{ $0.center = CGPoint(x: $0.center.x + shiftDown, y: $0.center.y + shiftDown)}
            }
        }) { (_) in
            self.animateButton.titleLabel?.text = self.isAnimation ? "Back" : "Animate"
            self.isAnimation = !self.isAnimation
        }
    }
    
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
}


extension UIView {
    // TODO: - KISS
    func createCross() {
        let step = self.bounds.width / 3
        
        let path = UIBezierPath()
        let start = CGPoint(x: step, y: 0)
        
        path.move(to: start)
        
        path.addLine(to: CGPoint(x: step * 2, y: 0))
        path.addLine(to: CGPoint(x: step * 2, y: step))
        path.addLine(to: CGPoint(x: step * 3, y: step))
        path.addLine(to: CGPoint(x: step * 3, y: step * 2))
        path.addLine(to: CGPoint(x: step * 2, y: step * 2))
        path.addLine(to: CGPoint(x: step * 2, y: step * 3))
        path.addLine(to: CGPoint(x: step,     y: step * 3))
        path.addLine(to: CGPoint(x: step,     y: step * 2))
        path.addLine(to: CGPoint(x: 0,        y: step * 2))
        path.addLine(to: CGPoint(x: 0,        y: step))
        path.addLine(to: CGPoint(x: step,     y: step))

        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.yellow.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
}
