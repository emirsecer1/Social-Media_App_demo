import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class ViewControllermesajekranı: UIViewController {
    @IBOutlet weak var mesajyazmatextfield: UITextField!
    @IBOutlet weak var isim: UILabel!
    var secilenisim = ""
    @IBOutlet weak var mesajkisi: UITextField!
    @IBOutlet weak var mesajiçeriğitext: UILabel!
    var currentUserEmail = "" // Kullanıcının e-postasını saklamak için bir değişken ekledik.

    @IBOutlet weak var yenimesajlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        isim.text = secilenisim
        currentUserEmail = Auth.auth().currentUser?.email ?? ""
        fetchLastMessage()
    }

    @IBAction func sendmessagebutton(_ sender: Any) {
        if let mesaj = mesajkisi.text, !mesaj.isEmpty {
            let db = Firestore.firestore()

            // Firestore "messages" koleksiyonuna yeni bir belge ekleyin
            db.collection("messages").addDocument(data: [
                "senderEmail": currentUserEmail, // Gönderenin e-postası
                "message": mesajyazmatextfield.text, // Mesaj içeriği
                "timestamp": FieldValue.serverTimestamp(), // Zaman damgası
                "recieverEmail" : mesajkisi.text
            ]) { error in
                if let error = error {
                    print("Mesaj gönderme hatası: \(error.localizedDescription)")
                } else {
                    print("Mesaj başarıyla gönderildi.")
                    self.mesajkisi.text = "" // Mesaj gönderildikten sonra metin alanını temizleyin.
                    self.fetchLastMessage()
                    // Yeni mesaj gönderildikten sonra son mesajı alın.
                    
                    
                    self.mesajiçeriğitext.text = self.mesajyazmatextfield.text
                }
            }
        }
    }

    func fetchLastMessage() {
        let db = Firestore.firestore()
        let query = db.collection("messages")
                      .whereField("senderEmail", isEqualTo: currentUserEmail)
                      .order(by: "timestamp", descending: true)
                      .limit(to: 1)

        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Son mesajı alma hatası: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("Hiç mesaj bulunamadı.")
                return
            }

            let lastMessage = documents[0].data()
            if let messageContent = lastMessage["message"] as? String {
                DispatchQueue.main.async {
                    self.mesajiçeriğitext.text = messageContent
                }
            }
        }
    }
    
    
    func fetchLastMessageForReceiver(receiverEmail: String) {
        let db = Firestore.firestore()
        let query = db.collection("messages")
            .whereField("recieverEmail", isEqualTo: receiverEmail)
            .order(by: "timestamp", descending: true)
            .limit(to: 1)

        query.getDocuments { (querySnapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
               return
            } else {
                guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                    print("Hiç mesaj bulunamadı.")
                   return
                    
                }
                
                let lastMessage = documents[0].data()
                if let messageContent = lastMessage["message"] as? String {
                    DispatchQueue.main.async {
                        self.yenimesajlabel.text = messageContent
                    }
                }
            }
        }
    }

}

