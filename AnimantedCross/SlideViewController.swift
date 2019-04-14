//
//  SlideViewController.swift
//  AnimantedCross
//
//  Created by Developer on 4/12/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class SlideViewController: UIViewController {

    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var slideViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideViewDistanceToTitle: NSLayoutConstraint!
    @IBOutlet weak var slideViewTopConstraint: NSLayoutConstraint!
    
    let visibleHeight: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        drawBackroundForView()
    }
}

extension SlideViewController {
    func configureTutorialView() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.slideView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.slideView.addGestureRecognizer(swipeDown)
    }
    
    func drawBackroundForView() {
        // Add innerPath for tutorialView
        let maskPath = UIBezierPath(roundedRect:        slideView.bounds,
                                    byRoundingCorners:  [.topLeft, .topRight],
                                    cornerRadii:        CGSize(width: 18, height: 18))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        slideView.layer.mask = shape
        slideView.layer.backgroundColor = UIColor.white.cgColor
        
        configureTutorialView()
    }
    
    
    func showTutorialView() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {
            self.slideViewTopConstraint.constant = -self.slideView.frame.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideTutorialView() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1, delay: 0.2, options: [.curveLinear], animations: {
            self.slideViewTopConstraint.constant = -self.visibleHeight
            self.view.layoutIfNeeded()
        },  completion: nil)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.up {
            showTutorialView()
        }
        else if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            hideTutorialView()
        }
    }
}
