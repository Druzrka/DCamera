//
//  RectangleDetector.swift
//  DCamera
//
//  Created by iMac_3 on 12/12/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit
import Vision

struct RectangleDetector {
  
  public func detectRectangle(in ciImage: CIImage, completion: @escaping (Quadrilateral?) -> Void) {
    
    let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: [:])
    let detectRequest = VNDetectRectanglesRequest { req, err in
      guard let observations = req.results as? [VNRectangleObservation],
        observations.count != 0,
        let quad = self.processObservations(observations, imageSize: ciImage.extent.size)
        else {
          
          completion(nil)
          return
      }
      
        completion(quad)
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
  
  private func processObservations(_ observations: [VNRectangleObservation], imageSize: CGSize) -> Quadrilateral? {
    
    var quads = [Quadrilateral]()
    for observation in observations {
      let topLeft = CGPoint(x: observation.topLeft.x * imageSize.width,
                            y: (1 - observation.topLeft.y) * imageSize.height)
      let bottomLeft = CGPoint(x: observation.bottomLeft.x * imageSize.width,
                               y: (1 - observation.bottomLeft.y) * imageSize.height)
      let topRight = CGPoint(x: observation.topRight.x * imageSize.width,
                             y: (1 - observation.topRight.y) * imageSize.height)
      let bottomRight = CGPoint(x: observation.bottomRight.x * imageSize.width,
                                y: (1 - observation.bottomRight.y) * imageSize.height)
      
      let quad = Quadrilateral(topLeft: topLeft,
                               bottomLeft: bottomLeft,
                               topRight: topRight,
                               bottomRight: bottomRight)
      quads.append(quad)
    }
    
    return quads.biggest()
  }
}
