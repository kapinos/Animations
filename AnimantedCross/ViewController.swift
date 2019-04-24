//
//  ViewController.swift
//  AnimantedCross
//
//  Created by Anastasia Kapinos on 4/9/19.
//  Copyright © 2019 Anastasia Kapinos. All rights reserved.
//

import UIKit

extension UIColor {
    struct GeometryColors {
        static var firstColor:  UIColor { return UIColor.yellow }
        static var secondColor: UIColor { return UIColor.black  }
        
        static func opposite(color: UIColor) -> UIColor {
            if color == firstColor  { return secondColor }
            if color == secondColor { return firstColor  }
            return .black
        }
    }
}


class ViewController: UIViewController {
    
    // MARK: - Properties
    private var firstViewWithCrosses    = CrossesStartView(frame: CGRect.zero)
    private var secondViewWithCubes     = CubesView(frame: CGRect.zero)
    private var thirdViewWithRhombuses  = RhombusesView(frame: CGRect.zero)
    private var fourthViewWithRhombuses = CrossesFinishView(frame: CGRect.zero)

    private let size: CGFloat = 30
    private let rotationCrossAngle: CGFloat = 90
    private let rotationCubesAngle: CGFloat = 45
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        restoreView()
        
        firstViewWithCrosses = CrossesStartView(frame: self.view.bounds, shapeSize: size,
                                                 color: UIColor.GeometryColors.firstColor, angle: -rotationCrossAngle)
        self.view.addSubview(firstViewWithCrosses)
        
        firstViewWithCrosses.animate(completion: {
            self.invertCrossesToCubes(to: UIColor.GeometryColors.secondColor)
            self.secondViewWithCubes.animate(completion: {
                self.invertCubesToRhombuses(to: UIColor.GeometryColors.firstColor)
                self.thirdViewWithRhombuses.animate(completion: {
                    self.invertRhombusesToCrosses(to: UIColor.GeometryColors.secondColor)
                    self.fourthViewWithRhombuses.animate(completion: { })
                })
            })
        })
    }
}

// MARK: - Creation Views for Animations
private extension ViewController {
    func restoreView() {
        _ = self.view.subviews.map{ $0.removeFromSuperview() }
        self.view.backgroundColor = UIColor.GeometryColors.secondColor
    }

    func invertCrossesToCubes(to color: UIColor) {
        self.secondViewWithCubes = CubesView(frame: view.bounds, shapeSize: size,
                                             color: color,
                                             views: firstViewWithCrosses.getSubviews(),
                                             angle: -rotationCubesAngle)
        self.view.addSubview(secondViewWithCubes)
        self.firstViewWithCrosses.removeFromSuperview()
    }
    
    func invertCubesToRhombuses(to color: UIColor) {
        self.thirdViewWithRhombuses = RhombusesView(frame: view.bounds, shapeSize: size,
                                                    color: color,
                                                    views: secondViewWithCubes.getSubviews(),
                                                    angle: rotationCubesAngle)
        self.view.addSubview(thirdViewWithRhombuses)
        self.secondViewWithCubes.removeFromSuperview()
    }
    
    func invertRhombusesToCrosses(to color: UIColor) {
        self.fourthViewWithRhombuses = CrossesFinishView(frame: view.bounds, shapeSize: size,
                                                         color: color,
                                                         views: thirdViewWithRhombuses.getSubviews(),
                                                         angle: rotationCrossAngle)
        self.view.addSubview(fourthViewWithRhombuses)
        self.thirdViewWithRhombuses.removeFromSuperview()
    }
}
