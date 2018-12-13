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
  
  private func convert(imagePoint: CGPoint, imageSize: CGSize) -> CGPoint {
    var viewPoint = imagePoint
    let viewSize = view.bounds.size
    
    let ratioX = viewSize.width / imageSize.width
    let ratioY = viewSize.height / imageSize.height
    
    let scale: CGFloat = max(ratioX, ratioY)
    
    viewPoint.x *= scale
    viewPoint.y *= scale
    viewPoint.x += (viewSize.width - imageSize.width * scale) / 2.0
    viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0
    
    return viewPoint
  }
  
  private func converRect(fromImageRect imageRect: CGRect, imageSize: CGSize) -> CGRect {
    
    let imageTopLeft = imageRect.origin
    let imageBottomRight = CGPoint(x: imageRect.maxX, y: imageRect.maxY)
    
    let viewTopLeft = convert(imagePoint: imageTopLeft, imageSize: imageSize)
    let viewBottomRight = convert(imagePoint: imageBottomRight, imageSize: imageSize)
    
    var viewRect: CGRect = .zero
    viewRect.origin = viewTopLeft
    viewRect.size = CGSize(width: abs(viewBottomRight.x - viewTopLeft.x), height: abs(viewBottomRight.y - viewTopLeft.y))
    return viewRect
  }
}

extension CameraViewController: CaputureSessionManagerDelegate {
  func didDetectQuad(quad: Quadrilateral?, imageSize: CGSize) {
    guard let quad = quad else {
      return
    }
    
    DispatchQueue.main.async {
      
      let topLeft = self.convert(imagePoint: quad.topLeft, imageSize: imageSize)
      let bottomLeft = self.convert(imagePoint: quad.bottomLeft, imageSize: imageSize)
      let bottomRight = self.convert(imagePoint: quad.bottomRight, imageSize: imageSize)
      let topRight = self.convert(imagePoint: quad.topRight, imageSize: imageSize)
      
      let viewQuad = Quadrilateral(topLeft: topLeft, bottomLeft: bottomLeft, topRight: topRight, bottomRight: bottomRight)
      self.quadView.drawQuad(viewQuad)
    }
  }
}
