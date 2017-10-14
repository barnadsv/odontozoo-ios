//
//  OdontogramaImagesHeaderViewControllerCollectionReusableView.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 14/10/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit

class OdontogramaImagesHeaderView: UICollectionReusableView, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    var myImages = [UIImage]()
    
    @IBOutlet weak var lblTitulo: UILabel!
    
    @IBOutlet weak var btCamera: UIButton!
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            //self.presentViewController(imagePicker, animated: true, completion: nil)
        }        
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myImages.append(pickedImage)
        }
        imagePicker.dismiss(animated:true, completion: nil)

        //dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        imagePicked.image = image
//        dismiss(animated:true, completion: nil)
//    }
//    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        imagePicker.dismiss(animated: true, completion: nil)
//        //imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//    }
}
