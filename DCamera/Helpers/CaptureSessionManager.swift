//
//  CaptureSessionManager.swift
//  DCamera
//
//  Created by iMac_3 on 12/12/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit
import AVFoundation

protocol CaputureSessionManagerDelegate: AnyObject {
  func didDetectQuad(quad: Quadrilateral?, imageSize: CGSize)
  func didCapturePhoto(photo: UIImage)
}

class CaptureSessionManager: NSObject {
  
  private let captureSession = AVCaptureSession()
  private let photoOutput = AVCapturePhotoOutput()
  private let outputDataQueue: DispatchQueue = {
    let queue = DispatchQueue(label: "Output data queue")
    return queue
  }()
  
  private let rectangeDetector = RectangleDetector()
  
  weak var delegate: CaputureSessionManagerDelegate?
  
  init(previewLayer: AVCaptureVideoPreviewLayer) {
    super.init()
    
    previewLayer.session = captureSession
    setupCaptureSession()
  }
  
  public func start() {
    if !captureSession.isRunning {
      captureSession.startRunning()
    }
  }
  
  public func stop() {
    captureSession.stopRunning()
  }
  
  public func takePhoto() {
    let photoSettings = AVCapturePhotoSettings()
    photoSettings.isAutoStillImageStabilizationEnabled = true
    
    if let photoOutputConnection = self.photoOutput.connection(with: .video) {
      photoOutputConnection.videoOrientation = AVCaptureVideoOrientation(deviceOrientation: UIDevice.current.orientation) ?? AVCaptureVideoOrientation.portrait
    }
    
    photoOutput.capturePhoto(with: photoSettings, delegate: self)
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
    
    if let bestFormat = bestFormat, let bestFrameRange = bestFrameRateRange {
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
}

extension CaptureSessionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    let imageBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
    let ciImage: CIImage = CIImage(cvImageBuffer: imageBuffer, options: [CIImageOption.applyOrientationProperty: 1])
  
    rectangeDetector.detectRectangle(in: ciImage) { quad in
      self.delegate?.didDetectQuad(quad: quad, imageSize: ciImage.extent.size)
    }
  }
}

extension CaptureSessionManager: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    
    DispatchQueue.global(qos: .utility).async {
      guard let photoData = photo.fileDataRepresentation(),
        let image = UIImage(data: photoData) else {
          return
      }
     
      DispatchQueue.main.async {
        self.delegate?.didCapturePhoto(photo: image.applyingPortraitOrientation())
      }
    }
  }
}
