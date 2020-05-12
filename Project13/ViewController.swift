//
//  ViewController.swift
//  Project13
//
//  Created by Roman Cebula on 12/05/2020.
//  Copyright © 2020 Roman Cebula. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var intensity: UISlider!
  
  var currentImage: UIImage!
  var context: CIContext!
  var currentFilter: CIFilter!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
  }
  
  @objc func importPicture(){
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  @IBAction func changeFilter(_ sender: Any) {
  }
  
  @IBAction func save(_ sender: Any) {
  }
  
  @IBAction func intensityChanged(_ sender: Any) {
    applyProcessing()
  }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else {return}
    dismiss(animated: true)
    currentImage = image
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }
  
  func applyProcessing(){
    guard let image = currentFilter.outputImage else {return}
    currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
    if let cgimg = context.createCGImage(image, from: image.extent){
      let processedImage = UIImage(cgImage: cgimg)
      imageView.image = processedImage
    }
  }
}
