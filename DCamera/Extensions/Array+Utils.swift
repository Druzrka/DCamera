//
//  Array+Utils.swift
//  DCamera
//
//  Created by iMac_3 on 12/12/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import Vision
import UIKit

extension Array where Element == Quadrilateral {
  
  /// Finds the biggest rectangle within an array of `Quadrilateral` objects.
  func biggest() -> Quadrilateral? {
    guard count > 1 else {
      return first
    }
    
    let biggestRectangle = self.max(by: { (rect1, rect2) -> Bool in
      return rect1.perimeter < rect2.perimeter
    })
    
    return biggestRectangle
  }
  
}
