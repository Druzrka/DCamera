//
//  CGPoint+Utils.swift
//  DCamera
//
//  Created by iMac_3 on 12/12/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit

extension CGPoint {
  
  /// Returns the distance between two points
  func distanceTo(point: CGPoint) -> CGFloat {
    return hypot((self.x - point.x), (self.y - point.y))
  }
}
