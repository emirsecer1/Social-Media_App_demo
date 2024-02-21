import UIKit
import CoreData
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage
import Firebase

class ViewControllerhesapayari: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var ayarlartableview: UITableView!
    @IBOutlet weak var iimageview: UIImageView!

    var postdizisi = [post]()

    // Core Data'da kullanılacak değişkenler
    var managedContext: NSManagedObjectContext!
    var fotografVeri: NSManagedObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        ayarlartableview.delegate = self
        ayarlartableview.dataSource = self
        firebaseverilerial()

        // Core Data context'ini alın
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iimageview.isUserInteractionEnabled = true
        iimageview.addGestureRecognizer(tapGestureRecognizer)

        // Kaydedilmiş fotoğraf varsa, görüntüyü yükle
        fetchFotografVeri()
    }

    func firebaseverilerial() {
        if let currentUser = Auth.auth().currentUser {
            let firestoreDb = Firestore.firestore()

            firestoreDb.collection("Post")
                .whereField("email", isEqualTo: currentUser.email)
                .order(by: "tarih", descending: true)
                .addSnapshotListener { [self] snapshot, error in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        if snapshot?.isEmpty != true && snapshot != nil {
                            self.postdizisi.removeAll(keepingCapacity: false)

                            for document in snapshot!.documents {
                                if let gorselurl = document.get("gorselurl") as? String {
                                    if let yorum = document.get("yorum") as? String {
                                        if let email = document.get("email") as? String {

                                            let post = post(email: email, yorum: yorum, gorselurl: gorselurl)
                                            self.postdizisi.append(post)
                                        }
                                    }
                                }
                                self.ayarlartableview.reloadData()
                            }
                        }
                    }
                }
        }
    }

    @objc func imageTapped() {
        openImagePicker()
    }

    func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true // Düzenleme aktif
        present(imagePicker, animated: true, completion: nil)
    }

    func saveImageToCoreData(imageData: Data) {
        // Core Data'ya kaydetme işlemi
        if let entity = NSEntityDescription.entity(forEntityName: "Fotograf_veri", in: managedContext) {
            if fotografVeri == nil {
                fotografVeri = NSManagedObject(entity: entity, insertInto: managedContext)
            }

            fotografVeri?.setValue(imageData, forKey: "fotograf")

            do {
                try managedContext.save()
                print("Fotoğraf başarıyla kaydedildi.")
            } catch let error as NSError {
                print("Kaydetme hatası: \(error), \(error.userInfo)")
            }
        }
    }

    func fetchFotografVeri() {
        // Kaydedilmiş fotoğrafı çekme işlemi
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Fotograf_veri")

        do {
            let results = try managedContext.fetch(fetchRequest)
            if let fetchedFotografVeri = results.first as? NSManagedObject,
               let imageData = fetchedFotografVeri.value(forKey: "fotograf") as? Data,
               let image = UIImage(data: imageData) {
                iimageview.image = image
                fotografVeri = fetchedFotografVeri
            }
        } catch let error as NSError {
            print("Fotoğraf çekme hatası: \(error), \(error.userInfo)")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if let imageData = editedImage.pngData() {
                saveImageToCoreData(imageData: imageData)
            }
            iimageview.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageData = originalImage.pngData() {
                saveImageToCoreData(imageData: imageData)
            }
            iimageview.image = originalImage
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postdizisi.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ayarlartableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! feedcell
        cell.epostatext.text = postdizisi[indexPath.row].email
        cell.yorumtext.text = postdizisi[indexPath.row].yorum
        cell.cellimage.sd_setImage(with: URL(string: self.postdizisi[indexPath.row].gorselurl))

        return cell
    }
}

