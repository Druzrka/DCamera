//
//  UIImage+Orientation.swift
//  DCamera
//
//  Created by Zakhar Azatyan on 12/18/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit

extension UIImage {
  
  /// Returns the same image with a portrait orientation.
  func applyingPortraitOrientation() -> UIImage {
    switch imageOrientation {
    case .up:
      return rotated(by: Measurement(value: Double.pi, unit: .radians), options: []) ?? self
    case .down:
      return rotated(by: Measurement(value: Double.pi, unit: .radians), options: [.flipOnVerticalAxis, .flipOnHorizontalAxis]) ?? self
    case .left:
      return self
    case .right:
      return rotated(by: Measurement(value: Double.pi / 2.0, unit: .radians), options: []) ?? self
    default:
      return self
    }
  }
  
  /// Data structure to easily express rotation options.
  struct RotationOptions: OptionSet {
    let rawValue: Int
    
    static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
    static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
  }
  
  /// Rotate the image by the given angle, and perform other transformations based on the passed in options.
  ///
  /// - Parameters:
  ///   - rotationAngle: The angle to rotate the image by.
  ///   - options: Options to apply to the image.
  /// - Returns: The new image rotated and optentially flipped (@see options).
  func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
    guard let cgImage = self.cgImage else { return nil }
    
    let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
    let transform = CGAffineTransform(rotationAngle: rotationInRadians)
    let cgImageSize = CGSize(width: cgImage.width, height: cgImage.height)
    var rect = CGRect(origin: .zero, size: cgImageSize).applying(transform)
    rect.origin = .zero
    
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    
    let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
    
    let image = renderer.image { renderContext in
      renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
      renderContext.cgContext.rotate(by: rotationInRadians)
      
      let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
      let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
      renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
      
      let drawRect = CGRect(origin: CGPoint(x: -cgImageSize.width / 2.0, y: -cgImageSize.height / 2.0), size: cgImageSize)
      renderContext.cgContext.draw(cgImage, in: drawRect)
    }
    
    return image
  }
  
  func fixedOrientation() -> UIImage {
    if imageOrientation == .up {
      return self
    }
    
    var transform: CGAffineTransform = CGAffineTransform.identity
    
    switch imageOrientation {
    case .down, .downMirrored:
      transform = transform.translatedBy(x: size.width, y: size.height)
      transform = transform.rotated(by: CGFloat.pi)
      
    case .left, .leftMirrored:
      transform = transform.translatedBy(x: size.width, y: 0)
      transform = transform.rotated(by: CGFloat.pi / 2.0)
      
    case .right, .rightMirrored:
      transform = transform.translatedBy(x: 0, y: size.height)
      transform = transform.rotated(by: CGFloat.pi / -2.0)
      
    case .up, .upMirrored:
      break
    }
    switch imageOrientation {
    case .upMirrored, .downMirrored:
      transform.translatedBy(x: size.width, y: 0)
      transform.scaledBy(x: -1, y: 1)
      
    case .leftMirrored, .rightMirrored:
      transform.translatedBy(x: size.height, y: 0)
      transform.scaledBy(x: -1, y: 1)
    case .up, .down, .left, .right:
      break
    }
    
    let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    
    ctx.concatenate(transform)
    
    switch imageOrientation {
    case .left, .leftMirrored, .right, .rightMirrored:
      ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
    default:
      ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
      
    }
    
    return UIImage(cgImage: ctx.makeImage()!)
  }
}
