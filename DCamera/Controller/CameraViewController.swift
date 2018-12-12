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
  @IBOutlet weak var imageView: UIImageView!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  private var captureSessionManager: CaptureSessionManager!

  override func viewDidLoad() {
    super.viewDidLoad()
    captureSessionManager = CaptureSessionManager(previewLayer: previewView.videoPreviewLayer)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    captureSessionManager.start()
  }
}


