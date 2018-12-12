//
//  CaptureSessionManager.swift
//  DCamera
//
//  Created by iMac_3 on 12/12/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureSessionManager: NSObject {
  
  private let captureSession = AVCaptureSession()
  private let outputDataQueue: DispatchQueue = {
    let queue = DispatchQueue(label: "Output data queue")
    return queue
  }()
  
  init(previewLayer: AVCaptureVideoPreviewLayer) {
    super.init()
    
    previewLayer.session = captureSession
    setupCaptureSession()
  }
  
  public func start() {
    captureSession.startRunning()
  }
  
  public func stop() {
    captureSession.stopRunning()
  }
  
  private func setupCaptureSession() {
    captureSession.beginConfiguration()
    setupCaptureSessionInputs()
    setupCaptureSessionOutputs()
    captureSession.commitConfiguration()
  }
  
  private func setupCaptureSessionInputs() {
    guard
      let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
      let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
      captureSession.canAddInput(videoDeviceInput)
      else { return }
    
    configureDeviceForHighestFrameRate(videoDevice)
    
    captureSession.addInput(videoDeviceInput)
  }
  
  private func setupCaptureSessionOutputs() {
    let photoOutput = AVCapturePhotoOutput()
    let dataOutput = AVCaptureVideoDataOutput()
    
    guard
      captureSession.canAddOutput(photoOutput),
      captureSession.canAddOutput(dataOutput)
      else { return }
    
    dataOutput.setSampleBufferDelegate(self, queue: outputDataQueue)
    
    captureSession.addOutput(dataOutput)
    captureSession.addOutput(photoOutput)
    
    dataOutput.connection(with: .video)?.videoOrientation = .portrait
  }
  
  private func configureDeviceForHighestFrameRate(_ device: AVCaptureDevice) {
    
    var bestFormat: AVCaptureDevice.Format? = nil
    var bestFrameRateRange: AVFrameRateRange? = nil
    
    for format in device.formats {
      for range in format.videoSupportedFrameRateRanges {
        if range.maxFrameRate > bestFrameRateRange?.maxFrameRate ?? 0 {
          bestFormat = format
          bestFrameRateRange = range
        }
      }
    }
    
    guard let bestFormat = bestFormat, let bestFrameRange = bestFrameRateRange else {
      return
    }
    
    do {
      try device.lockForConfiguration()
      device.activeFormat = bestFormat
      device.activeVideoMinFrameDuration = bestFrameRange.minFrameDuration
      device.activeVideoMaxFrameDuration = bestFrameRange.maxFrameDuration
      device.unlockForConfiguration()
    } catch {
      print(error)
    }
  }
}

extension CaptureSessionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
    let ciImage: CIImage = CIImage(cvImageBuffer: imageBuffer, options: [CIImageOption.applyOrientationProperty: 1])
    let image: UIImage = UIImage(ciImage: ciImage, scale: 1.0, orientation: .up)
  }
}
