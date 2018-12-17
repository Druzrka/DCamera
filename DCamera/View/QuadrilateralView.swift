//
//  QuadrilateralView.swift
//  DCamera
//
//  Created by iMac_3 on 12/13/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit

class QuadrilateralView: UIView {
  
  private let lineWidth: CGFloat = 2.0
  
  private lazy var quadLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.orange.cgColor
    layer.fillColor = UIColor.orange.withAlphaComponent(0.3).cgColor
    layer.lineWidth = self.lineWidth
    return layer
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.addSublayer(quadLayer)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    layer.addSublayer(quadLayer)
  }
  
  func drawQuad(_ quad: Quadrilateral) {
    let path = quad.path
    
    let pathAnimation = CABasicAnimation(keyPath: "path")
    pathAnimation.duration = 0.2
    quadLayer.add(pathAnimation, forKey: "path")
    
    quadLayer.path = path.cgPath
  }
}
