//
//  SlideViewController.swift
//  AnimantedCross
//
//  Created by Developer on 4/12/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

private enum State {
    case closed
    case open

    var opposite: State {
        switch self {
        case .open:     return .closed
        case .closed:   return .open
        }
    }
}

class SlideViewController: UIViewController {

    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var walkView: UIView!
    @IBOutlet weak var carView: UIView!
    
    private var slideViewBottomConstraint = NSLayoutConstraint()
    
    private var currentState = State.closed
    private var transitionAnimator = UIViewPropertyAnimator()
    private var animationProgress: CGFloat = 0
    
    private let slideViewHeight: CGFloat = 400
    private let slideViewVisiblePart: CGFloat = 80
    private var slideViewHeightAnchor: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()

        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(slideViewPanned(recognizer:)))
        self.slideView.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: - User Interactions
private extension SlideViewController {
    @objc private func slideViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1.5)
            transitionAnimator.pauseAnimation()
            animationProgress = transitionAnimator.fractionComplete
            
        case .changed:
            let translation = recognizer.translation(in: slideView)
            var fraction = -translation.y / slideViewHeight
            if currentState == .open { fraction *= -1 }
            transitionAnimator.fractionComplete = fraction + animationProgress
            
        case .ended:
            let yVelocity = recognizer.velocity(in: slideView).y
            let shouldClose = yVelocity > 0
            if yVelocity == 0 {
                transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                break
            }
            switch currentState {
            case .open:
                if !shouldClose && !transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
                if shouldClose && transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
            case .closed:
                if shouldClose && !transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
                if !shouldClose && transitionAnimator.isReversed { transitionAnimator.isReversed = !transitionAnimator.isReversed }
            }
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            
        default: ()
        }
    }
    
    func animateTransitionIfNeeded(to state: State, duration: CGFloat) {
        let state = currentState.opposite
        transitionAnimator = UIViewPropertyAnimator(duration: 1, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.slideViewBottomConstraint.constant = 0
                
                let shiftYToSlideView = self.view.bounds.height - self.slideViewHeightAnchor - 130
                
                self.titleView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                    .concatenating(CGAffineTransform(translationX: 0, y: -shiftYToSlideView))
                self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -shiftYToSlideView)
                self.titleLabel.alpha = 0.55
                self.titleView.alpha = 0.7
                
                self.walkView.transform = CGAffineTransform(translationX: 0, y: -100)
                self.carView.transform = CGAffineTransform(translationX: 0, y: -100)
                self.walkView.alpha = 0
                self.carView.alpha = 0
                
            case .closed:
                self.slideViewBottomConstraint.constant = self.slideViewHeight
                
                self.titleView.transform = .identity
                self.titleLabel.transform = .identity
                self.titleLabel.alpha = 1
                
                self.walkView.transform = .identity
                self.carView.transform = .identity
                self.walkView.alpha = 1
                self.carView.alpha = 1
                
            }
            self.view.layoutIfNeeded()
        })
        
        transitionAnimator.addCompletion { position in
            switch position {
            case .start:    self.currentState = state.opposite
            case .end:      self.currentState = state
            case .current:  ()
            }
            
            switch self.currentState {
            case .open:     self.slideViewBottomConstraint.constant = 0
            case .closed:   self.slideViewBottomConstraint.constant = self.slideViewHeight
            }
        }
        transitionAnimator.startAnimation()
    }
}


// MARK: - Private
private extension SlideViewController {
    func layout() {
        // - slideView
        slideView.translatesAutoresizingMaskIntoConstraints = false
        slideView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        slideView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        slideViewBottomConstraint = slideView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: slideViewHeight)
        slideViewBottomConstraint.isActive = true
        
        slideViewHeightAnchor = slideViewHeight + slideViewVisiblePart + (self.tabBarController?.tabBar.frame.height ?? 0)
        slideView.heightAnchor.constraint(equalToConstant: slideViewHeightAnchor).isActive = true
        slideView.layer.cornerRadius = 20
        slideView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // - other views
        titleView.layer.cornerRadius = titleView.frame.height / 2
        carView.layer.cornerRadius   = 45
        walkView.layer.cornerRadius  = 45
        
        carView.layer.masksToBounds = true
        walkView.layer.masksToBounds = true
    }
}
