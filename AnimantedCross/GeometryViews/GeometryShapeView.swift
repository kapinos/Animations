//
//  GeometryShapeView.swift
//  AnimantedCross
//
//  Created by Developer on 4/23/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

protocol GeometryShapesProtocol: class {
    func createSubviews(from views: [[UIView]]?, with color: UIColor)
    func animate(completion: @escaping ()->())
}

class GeometryShapeView: UIView {

    var shapesSubviews = [[UIView]]()
    var size: CGFloat = 0
    var angle: CGFloat = 0
    var color = UIColor.black
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, size: CGFloat, color: UIColor, angle: CGFloat) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.GeometryColors.opposite(color: color)
        self.size = size
        self.color = color
        self.angle = angle
    }
    
    init(frame: CGRect, size: CGFloat, color: UIColor, views: [[UIView]]?, angle: CGFloat) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.GeometryColors.opposite(color: color)
        self.size = size
        self.color = color
        self.angle = angle
    }
    
    func getSubviews() -> [[UIView]] {
        return self.shapesSubviews
    }
}
