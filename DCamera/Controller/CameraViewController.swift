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
  @IBOutlet weak var quadView: QuadrilateralView!
  
  private var quadIsDetected: Bool = false {
    didSet {
      DispatchQueue.main.async {
        self.quadView.isHidden = !self.quadIsDetected
      }
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  private var captureSessionManager: CaptureSessionManager!

  // MARK: Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCaptureSessionManager()
    configureQuadView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    captureSessionManager.start()
  }
  
  // MARK: - Setups
  private func setupCaptureSessionManager() {
    captureSessionManager = CaptureSessionManager(previewLayer: previewView.videoPreviewLayer)
    captureSessionManager.delegate = self
  }
  
  // MARK: Configure
  private func configureQuadView() {
    quadView.backgroundColor = .clear
  }
  
  // MARK: - Actions
  @IBAction func shutterButtonPressed(_ sender: Any) {
    captureSessionManager.takePhoto()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let dest = segue.destination as? PhotoViewController {
      dest.image = sender as? UIImage
    }
  }
}

extension CameraViewController: CaputureSessionManagerDelegate {
  
  func didCapturePhoto(photo: UIImage) {
    performSegue(withIdentifier: "showPhoto", sender: photo)
  }
  
  func didDetectQuad(quad: Quadrilateral?, imageSize: CGSize) {
    guard let quad = quad else {
      quadIsDetected = false
      return
    }
    
    quadIsDetected = true
    
    DispatchQueue.main.async {
      
      let topLeft = self.previewView.convertPoint(imagePoint: quad.topLeft, imageSize: imageSize)
      let bottomLeft = self.previewView.convertPoint(imagePoint: quad.bottomLeft, imageSize: imageSize)
      let bottomRight = self.previewView.convertPoint(imagePoint: quad.bottomRight, imageSize: imageSize)
      let topRight = self.previewView.convertPoint(imagePoint: quad.topRight, imageSize: imageSize)
      
      let viewQuad = Quadrilateral(topLeft: topLeft, bottomLeft: bottomLeft, topRight: topRight, bottomRight: bottomRight)
      self.quadView.drawQuad(viewQuad)
    }
  }
}
