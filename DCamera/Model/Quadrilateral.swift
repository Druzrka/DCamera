//
//  Quadrilateral.swift
//  DCamera
//
//  Created by iMac_3 on 12/12/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit

struct Quadrilateral {
  
  let topLeft: CGPoint
  let bottomLeft: CGPoint
  let topRight: CGPoint
  let bottomRight: CGPoint
  
  let size: CGSize
  
  init(topLeft: CGPoint, bottomLeft: CGPoint, topRight: CGPoint, bottomRight: CGPoint) {
    self.topLeft = topLeft
    self.bottomLeft = bottomLeft
    self.topRight = topRight
    self.bottomRight = bottomRight
    
    self.size = CGSize(width: bottomRight.x - bottomLeft.x,
                       height: bottomRight.y - topRight.y)
  }
  
  var perimeter: Double {
    let perimeter = topLeft.distanceTo(point: topRight) + topRight.distanceTo(point: bottomRight) + bottomRight.distanceTo(point: bottomLeft) + bottomLeft.distanceTo(point: topLeft)
    return Double(perimeter)
  }
}

extension Quadrilateral: Comparable {
  static func < (lhs: Quadrilateral, rhs: Quadrilateral) -> Bool {
    return lhs.perimeter < rhs.perimeter
  }
  
  static func > (lhs: Quadrilateral, rhs: Quadrilateral) -> Bool {
    return lhs.perimeter > rhs.perimeter
  }
}

extension Quadrilateral: Equatable {
  public static func == (lhs: Quadrilateral, rhs: Quadrilateral) -> Bool {
    return lhs.topLeft == rhs.topLeft && lhs.topRight == rhs.topRight && lhs.bottomRight == rhs.bottomRight && lhs.bottomLeft == rhs.bottomLeft
  }
}
