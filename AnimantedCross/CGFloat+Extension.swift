//
//  CGFloat+Extension.swift
//  AnimantedCross
//
//  Created by Developer on 4/23/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180
    }
}
