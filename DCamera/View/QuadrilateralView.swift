//
//  QuadrilateralView.swift
//  DCamera
//
//  Created by iMac_3 on 12/13/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit

class QuadrilateralView: UIView {
  
  var path: UIBezierPath!
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    guard path != nil else {
      return
    }
    
    UIColor.orange.setStroke()
    path.stroke()
  }
  
  func drawQuad(_ quad: Quadrilateral) {
    path = UIBezierPath()
    path.lineWidth = 3
    
    path.move(to: quad.topLeft)
    path.addLine(to: quad.bottomLeft)
    path.addLine(to: quad.bottomRight)
    path.addLine(to: quad.topRight)
    path.close()
    
    setNeedsDisplay()
  }
}
