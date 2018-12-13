//
//  TestViewController.swift
//  DCamera
//
//  Created by iMac_3 on 12/12/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit
import Vision

class TestViewController: UIViewController {
  
  let image = UIImage(named: "rec")!
  lazy var imageView = UIImageView(image: image)
  
  private let quadLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.strokeColor = UIColor.red.cgColor
    layer.lineWidth = 2.0
    layer.opacity = 1.0
    layer.isHidden = true
    
    return layer
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.layer.addSublayer(quadLayer)
    setupImageView()
  }
  
  private func setupImageView() {
    
    imageView.backgroundColor = .blue
    imageView.contentMode = .scaleAspectFit
    
    let height = view.frame.height
    let width = view.frame.width
    
    imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
//    view.addSubview(imageView)
  }
}
