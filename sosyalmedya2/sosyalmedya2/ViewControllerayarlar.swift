import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

class ViewControllerayarlar: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.green.cgColor, UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        
        view.layer.insertSublayer(gradientLayer, at: 0)

     
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    @IBAction func cikisyapbutton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "tocıkısvc", sender: nil)
        } catch {
            print("hata")
        }
    }
}

