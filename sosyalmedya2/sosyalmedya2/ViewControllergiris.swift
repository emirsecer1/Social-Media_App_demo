import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseAnalytics
import FirebaseFirestore

class ViewControllergiris: UIViewController, UITextFieldDelegate {
    let appdelagate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var sifretext: UITextField!
    @IBOutlet weak var epostatext: UITextField!

    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimatedBackground()
        epostatext.delegate = self
        sifretext.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @IBAction func girisyapbutton(_ sender: Any) {
        Auth.auth().signIn(withEmail: epostatext.text ?? "hata aldınız ", password: sifretext.text ?? "hata aldınız" ) { AuthDataResult, Error in
            if Error  != nil {
                self.alertOlustur(titleGirdisi: "hata", messageGirdisi: Error?.localizedDescription ?? "hata aldınız")
            } else {
                self.performSegue(withIdentifier: "toanasayfavc", sender: nil)
            }
        }
        
    }

    @IBAction func kaydolbutton(_ sender: UIButton) {
        guard let email = epostatext.text, !email.isEmpty else {
            alertOlustur(titleGirdisi: "Hata", messageGirdisi: "Eposta alanı boş bırakılamaz.")
            return
        }

        guard let password = sifretext.text, !password.isEmpty else {
            alertOlustur(titleGirdisi: "Hata", messageGirdisi: "Şifre alanı boş bırakılamaz.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.alertOlustur(titleGirdisi: "Hata", messageGirdisi: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "toanasayfavc", sender: nil)
            }
        }
    }

    func setupAnimatedBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.orange.cgColor, UIColor.brown.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        
        // Arkaplanın hareketli olmasını istiyorsak, gradientLayer'ı animasyon eklemeliyiz.
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [UIColor.orange.cgColor, UIColor.brown.cgColor]
        animation.toValue = [UIColor.brown.cgColor, UIColor.orange.cgColor]
        animation.autoreverses = true
        animation.duration = 250 // Animasyon süresi (saniye cinsinden)
        animation.repeatCount = Float.infinity // Sonsuz tekrar
        
        gradientLayer.add(animation, forKey: "gradientAnimation")
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func alertOlustur(titleGirdisi: String, messageGirdisi: String) {
        let uyariMesaji = UIAlertController(title: titleGirdisi, message: messageGirdisi, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            print("OK butonuna tıklandı")
        }
        
        uyariMesaji.addAction(okButton)
        
        self.present(uyariMesaji, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

