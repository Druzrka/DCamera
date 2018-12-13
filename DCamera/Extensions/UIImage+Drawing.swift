//
//  UIImage+Drawing.swift
//  DCamera
//
//  Created by iMac_3 on 12/13/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit

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
