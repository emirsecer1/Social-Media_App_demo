//
//  uploadViewController.swift
//  sosyalmedya2
//
//  Created by Emir Seçer on 12.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class uploadViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate { 

    @IBOutlet weak var yorumtext: UITextField!
    @IBOutlet weak var uploadimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadimage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        uploadimage.addGestureRecognizer(gestureRecognizer)
        

        
    }
    


    @objc func gorselSec() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadimage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func uploadbutton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadimage.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (storagemetadata, error) in
                if error != nil {
                    self.hataMesajiGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyin!")
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            if let imageUrl = imageUrl {
                                let firestore = Firestore.firestore()
                                let firestorePost = ["gorselurl" : imageUrl, "yorum" : self.yorumtext.text, "email":  Auth.auth().currentUser?.email, "tarih" : FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestore.collection("Post").addDocument(data: firestorePost) { (error) in
                                    if error != nil {
                                        self.hataMesajiGoster(title: "HATA", message: error?.localizedDescription ?? "Hata aldınız")
                                    } else {
                                        print("başarılı oldunuz yüklendi.")
                                        self.uploadimage.image = UIImage(named: "gorselsec")
                                        self.yorumtext.text = ""
                                        self.tabBarController?.selectedIndex = 0
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func hataMesajiGoster(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
