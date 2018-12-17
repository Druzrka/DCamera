//
//  CameraViewController.swift
//  DCamera
//
//  Created by iMac_3 on 12/10/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: BaseViewController {
  
  @IBOutlet weak var previewView: PreviewView!
  private let quadView = QuadrilateralView(frame: .zero)
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  private var captureSessionManager: CaptureSessionManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    quadView.backgroundColor = .clear
    quadView.frame = view.bounds
    view.addSubview(quadView)
    
    captureSessionManager = CaptureSessionManager(previewLayer: previewView.videoPreviewLayer)
    captureSessionManager.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    captureSessionManager.start()
  }
}

extension CameraViewController: CaputureSessionManagerDelegate {
  func didDetectQuad(quad: Quadrilateral?, imageSize: CGSize) {
    guard let quad = quad else {
      return
    }
    
    DispatchQueue.main.async {
      
      let topLeft = UIView.convertPoint(imagePoint: quad.topLeft, imageSize: imageSize, viewSize: self.view.bounds.size)
      let bottomLeft = UIView.convertPoint(imagePoint: quad.bottomLeft, imageSize: imageSize, viewSize: self.view.bounds.size)
      let bottomRight = UIView.convertPoint(imagePoint: quad.bottomRight, imageSize: imageSize, viewSize: self.view.bounds.size)
      let topRight = UIView.convertPoint(imagePoint: quad.topRight, imageSize: imageSize, viewSize: self.view.bounds.size)
      
      let viewQuad = Quadrilateral(topLeft: topLeft, bottomLeft: bottomLeft, topRight: topRight, bottomRight: bottomRight)
      self.quadView.drawQuad(viewQuad)
    }
  }
}
