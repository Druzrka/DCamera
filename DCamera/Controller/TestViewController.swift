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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupImageView()
    detectRec()
  }
  
  private func setupImageView() {
    
    imageView.backgroundColor = .blue
    imageView.contentMode = .scaleAspectFill
    
    let scale = image.size.height / image.size.width
    let height = view.frame.width * scale
    let width = view.frame.width
    
    imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    view.addSubview(imageView)
  }
  
  private func detectRec() {
    
    let imageRequestHandler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: .up, options: [:])
    
    let detectRequest = VNDetectRectanglesRequest { req, err in
      
      guard let observation = req.results?[1] as? VNRectangleObservation else { return }
      
      let points = [observation.bottomLeft, observation.topRight, observation.bottomRight, observation.topLeft]
      
      let circle = UIImage(named: "circle")!
      var tempImage = self.image
      
      for point in points {
        let x = point.x * self.image.size.width
        let y = (1 - point.y) * self.image.size.height
        let size: CGFloat = 30.0
        
        tempImage = tempImage.image(byDrawingImage: circle, inRect: CGRect(x: x - size / 2, y: y - size / 2, width: size, height: size))
      }
      
      self.imageView.image = tempImage
    }
    
    detectRequest.maximumObservations = 8
    detectRequest.minimumConfidence = 0.6
    detectRequest.minimumAspectRatio = 0.3
    
    do {
      try imageRequestHandler.perform([detectRequest])
    } catch {
      print(error)
    }
  }
}

extension UIImage {
  
  func image(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage! {
    UIGraphicsBeginImageContext(size)
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    image.draw(in: rect)
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
  }
}

extension UIImageView {
  
  func convertPoint(fromImagePoint imagePoint: CGPoint) -> CGPoint {
    guard let imageSize = image?.size else { return CGPoint.zero }
    
    var viewPoint = imagePoint
    let viewSize = bounds.size
    
    let ratioX = viewSize.width / imageSize.width
    let ratioY = viewSize.height / imageSize.height
    
    switch contentMode {
    case .scaleAspectFit: fallthrough
    case .scaleAspectFill:
      var scale : CGFloat = 0
      
      if contentMode == .scaleAspectFit {
        scale = min(ratioX, ratioY)
      }
      else {
        scale = max(ratioX, ratioY)
      }
      
      viewPoint.x *= scale
      viewPoint.y *= scale
      
      viewPoint.x += (viewSize.width  - imageSize.width  * scale) / 2.0
      viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0
      
    case .scaleToFill: fallthrough
    case .redraw:
      viewPoint.x *= ratioX
      viewPoint.y *= ratioY
    case .center:
      viewPoint.x += viewSize.width / 2.0  - imageSize.width  / 2.0
      viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
    case .top:
      viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
    case .bottom:
      viewPoint.x += viewSize.width / 2.0 - imageSize.width / 2.0
      viewPoint.y += viewSize.height - imageSize.height
    case .left:
      viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
    case .right:
      viewPoint.x += viewSize.width - imageSize.width
      viewPoint.y += viewSize.height / 2.0 - imageSize.height / 2.0
    case .topRight:
      viewPoint.x += viewSize.width - imageSize.width
    case .bottomLeft:
      viewPoint.y += viewSize.height - imageSize.height
    case .bottomRight:
      viewPoint.x += viewSize.width  - imageSize.width
      viewPoint.y += viewSize.height - imageSize.height
    case.topLeft: fallthrough
    default:
      break
    }
    
    return viewPoint
  }
  
  func convertRect(fromImageRect imageRect: CGRect) -> CGRect {
    let imageTopLeft = imageRect.origin
    let imageBottomRight = CGPoint(x: imageRect.maxX, y: imageRect.maxY)
    
    let viewTopLeft = convertPoint(fromImagePoint: imageTopLeft)
    let viewBottomRight = convertPoint(fromImagePoint: imageBottomRight)
    
    var viewRect : CGRect = .zero
    viewRect.origin = viewTopLeft
    viewRect.size = CGSize(width: abs(viewBottomRight.x - viewTopLeft.x), height: abs(viewBottomRight.y - viewTopLeft.y))
    return viewRect
  }
  
  func convertPoint(fromViewPoint viewPoint: CGPoint) -> CGPoint {
    guard let imageSize = image?.size else { return CGPoint.zero }
    
    var imagePoint = viewPoint
    let viewSize = bounds.size
    
    let ratioX = viewSize.width / imageSize.width
    let ratioY = viewSize.height / imageSize.height
    
    switch contentMode {
    case .scaleAspectFit: fallthrough
    case .scaleAspectFill:
      var scale : CGFloat = 0
      
      if contentMode == .scaleAspectFit {
        scale = min(ratioX, ratioY)
      }
      else {
        scale = max(ratioX, ratioY)
      }
      
      // Remove the x or y margin added in FitMode
      imagePoint.x -= (viewSize.width  - imageSize.width  * scale) / 2.0
      imagePoint.y -= (viewSize.height - imageSize.height * scale) / 2.0
      
      imagePoint.x /= scale;
      imagePoint.y /= scale;
      
    case .scaleToFill: fallthrough
    case .redraw:
      imagePoint.x /= ratioX
      imagePoint.y /= ratioY
    case .center:
      imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
      imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
    case .top:
      imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
    case .bottom:
      imagePoint.x -= (viewSize.width - imageSize.width)  / 2.0
      imagePoint.y -= (viewSize.height - imageSize.height);
    case .left:
      imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
    case .right:
      imagePoint.x -= (viewSize.width - imageSize.width);
      imagePoint.y -= (viewSize.height - imageSize.height) / 2.0
    case .topRight:
      imagePoint.x -= (viewSize.width - imageSize.width);
    case .bottomLeft:
      imagePoint.y -= (viewSize.height - imageSize.height);
    case .bottomRight:
      imagePoint.x -= (viewSize.width - imageSize.width)
      imagePoint.y -= (viewSize.height - imageSize.height)
    case.topLeft: fallthrough
    default:
      break
    }
    
    return imagePoint
  }
  
  func convertRect(fromViewRect viewRect : CGRect) -> CGRect {
    let viewTopLeft = viewRect.origin
    let viewBottomRight = CGPoint(x: viewRect.maxX, y: viewRect.maxY)
    
    let imageTopLeft = convertPoint(fromImagePoint: viewTopLeft)
    let imageBottomRight = convertPoint(fromImagePoint: viewBottomRight)
    
    var imageRect : CGRect = .zero
    imageRect.origin = imageTopLeft
    imageRect.size = CGSize(width: abs(imageBottomRight.x - imageTopLeft.x), height: abs(imageBottomRight.y - imageTopLeft.y))
    return imageRect
  }
  
}
