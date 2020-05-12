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
    title = "InstaFilter"
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
    let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
     ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
       ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  private func setFilter(action: UIAlertAction){
    guard currentImage != nil else {return}
    guard let actionTitle = action.title else {return}
    currentFilter = CIFilter(name: actionTitle)
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
    applyProcessing()
  }
  
  @IBAction func save(_ sender: Any) {
    guard let image = imageView.image else {return}
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
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
    let inputKeys = currentFilter.inputKeys
    if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)  }
    if inputKeys.contains(kCIInputRadiusKey) {currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)}
    if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)}
    if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.width / 2), forKey: kCIInputCenterKey)}
    
    if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
      let processedImage = UIImage(cgImage: cgimg)
      self.imageView.image = processedImage
    }
  }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default ))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default ))
            present(ac, animated: true)
        }
    }
}
