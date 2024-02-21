//
//  ViewControllermsjyontemi.swift
//  sosyalmedya2
//
//  Created by Emir Seçer on 24.08.2023.
//

import UIKit

class ViewControllermsjyontemi: UIViewController {
    var secilenkisi = ""
   

    @IBOutlet weak var isimlabell: UILabel!
    @IBOutlet weak var isimlabel: UILabel!
    override func viewDidLoad() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.brown.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isimlabel.text = secilenkisi
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tomesaj" {
            if let destinion = segue.destination as? ViewControllermesajekranı {
                destinion.secilenisim = secilenkisi
            }
    }
    
}

}
