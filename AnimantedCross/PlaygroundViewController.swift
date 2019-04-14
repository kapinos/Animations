//
//  PlaygroundViewController.swift
//  AnimantedCross
//
//  Created by Developer on 4/11/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class PlaygroundViewController: UIViewController {

    var squareRed = UIView()
    var squareGreen = UIView()
    var squareWhite = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        squareRed = UIView(frame: CGRect(x: 250, y: 100, width: 50, height: 50))
        squareRed.backgroundColor = .red
        self.view.addSubview(squareRed)
        
        squareGreen = UIView(frame: CGRect(x: 250, y: 250, width: 50, height: 50))
        squareGreen.backgroundColor = .green
        self.view.addSubview(squareGreen)
        
        squareWhite = UIView(frame: CGRect(x: 250, y: 400, width: 50, height: 50))
        squareWhite.backgroundColor = .white
        self.view.addSubview(squareWhite)
    }
    
    

    @IBAction func animateButtonPressed(_ sender: UIButton) {
        let shift: CGFloat = 10
        
        // (2) squareGreen
        UIView.animate(withDuration: 1, delay: 0.1, options: .curveLinear, animations: {
            self.squareGreen.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(-90))
        }) { (_) in }
        
        // (4) SquareWhite
        let start = self.squareWhite.center
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubicPaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                self.squareWhite.transform = CGAffineTransform(rotationAngle: self.degreesToRadians(-90))
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.squareWhite.center = CGPoint(x: start.x + shift, y: start.y + shift)
            }
        })
    }
    
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(Double.pi) / 180.0
    }
}
