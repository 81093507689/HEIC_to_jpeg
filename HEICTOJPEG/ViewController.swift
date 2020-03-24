//
//  ViewController.swift
//  HEICTOJPEG
//
//  Created by developer on 24/03/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController {

    let pickerController = UIImagePickerController()
       var asset: PHAsset?
    @IBOutlet weak var imgMain: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let status = PHPhotoLibrary.authorizationStatus()
               if status == .notDetermined  {
                   PHPhotoLibrary.requestAuthorization({_ in})
               }
        
        
    }

    @IBAction func action_openImagePicker(sender:UIButton)
    {
          pickerController.delegate = self
          pickerController.allowsEditing = false
          pickerController.mediaTypes = ["public.image"]
          pickerController.sourceType = .photoLibrary
          present(pickerController, animated: true, completion: nil)
    }

    
    
    func editHEICTOJPEG()
    {
        if let _asset = self.asset {
            //let dispatchQueue = DispatchQueue.main
            
            let options = PHContentEditingInputRequestOptions()
            options.isNetworkAccessAllowed = true
            _asset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                let fullURL: URL?
                fullURL = contentEditingInput!.fullSizeImageURL
                ///.... if need to output the file so we have use this code
//                let output = PHContentEditingOutput(contentEditingInput:
//                    contentEditingInput!)
//                let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: "HEICEditor", requiringSecureCoding: false)
//                let adjustmentData =
//                    PHAdjustmentData(formatIdentifier:
//                        "HEICEditor.App",
//                                     formatVersion: "1.0",
//                                     data: archivedData!)
//
//                output.adjustmentData = adjustmentData
                let imageData = UIImage.init(contentsOfFile: fullURL!.path)?.jpegData(compressionQuality: 0.5)
                //print("PathImage--->",output.renderedContentURL)
//                do {
//                    try imageData!.write(to: output.renderedContentURL, options: .atomic)
//                } catch let error {
//                    print("error writing data:\(error)")
//                    self.dismiss(animated: true, completion: nil)
//                }
                if let _imageData = imageData
                {
                    self.imgMain.image = UIImage(data:_imageData,scale:1.0)
                    self.dismiss(animated: true, completion: nil)
                }
                
                
            })
            
        }else
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
}



extension ViewController : UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           
           
           guard let image = info[UIImagePickerController.InfoKey.originalImage]
               as? UIImage else {
                    self.dismiss(animated: true, completion: nil)
                   return
           }
           
           let assetPath = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
           
           if (assetPath.absoluteString?.hasSuffix("HEIC"))! {
               
               if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                   self.asset = asset
               }
               self.editHEICTOJPEG()
             
           }else
           {
              self.imgMain.image = image
               dismiss(animated: true, completion: nil)
           }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
