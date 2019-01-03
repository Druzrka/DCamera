//
//  UIView+CovertingCoordinates.swift
//  Scanner
//
//  Created by iMac_3 on 12/14/18.
//  Copyright © 2018 Artal. All rights reserved.
//

import UIKit

extension UIView {
  
  static func convertPoint(viewPoint: CGPoint, imageSize: CGSize, fromViewRect: CGRect) -> CGPoint {
    
    var imagePoint = viewPoint
    let viewSize = fromViewRect.size
    
    let ratioX = viewSize.width / imageSize.width
    let ratioY = viewSize.height / imageSize.height
    
    let scale = max(ratioX, ratioY)
    
    imagePoint.x -= (viewSize.width - imageSize.width * scale) / 2.0
    imagePoint.y -= (viewSize.height - imageSize.height * scale) / 2.0
    
    imagePoint.x /= scale
    imagePoint.y /= scale
    
    return imagePoint
  }
  
  func convertPoint(imagePoint: CGPoint, imageSize: CGSize) -> CGPoint {
    var viewPoint = imagePoint
    let viewSize = self.bounds.size

    let ratioX = viewSize.width / imageSize.width
    let ratioY = viewSize.height / imageSize.height
    
    let scale: CGFloat = max(ratioX, ratioY)
    
    viewPoint.x *= scale
    viewPoint.y *= scale
    viewPoint.x += (viewSize.width - imageSize.width * scale) / 2.0
    viewPoint.y += (viewSize.height - imageSize.height * scale) / 2.0
    
    return viewPoint
  }
  
  func converRect(fromImageRect imageRect: CGRect, imageSize: CGSize, viewSize: CGSize) -> CGRect {
    
    let imageTopLeft = imageRect.origin
    let imageBottomRight = CGPoint(x: imageRect.maxX, y: imageRect.maxY)
    
    let viewTopLeft = convertPoint(imagePoint: imageTopLeft, imageSize: imageSize)
    let viewBottomRight = convertPoint(imagePoint: imageBottomRight, imageSize: imageSize)
    
    var viewRect: CGRect = .zero
    viewRect.origin = viewTopLeft
    viewRect.size = CGSize(width: abs(viewBottomRight.x - viewTopLeft.x), height: abs(viewBottomRight.y - viewTopLeft.y))
    return viewRect
  }
}
