//
//  PreviewView.swift
//  DCamera
//
//  Created by iMac_3 on 12/10/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
  
  override class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }
  
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    let previewlayer = layer as! AVCaptureVideoPreviewLayer
    previewlayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
    
    return previewlayer
  }
}
