//
//  PhotoViewController.swift
//  DCamera
//
//  Created by Zakhar Azatyan on 12/17/18.
//  Copyright © 2018 iMac_3. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  
  public var image: UIImage!
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = image
  }
  
  @IBAction func b() {
    dismiss(animated: false)
  }
}
