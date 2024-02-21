import UIKit

class ViewControllerdmkisisecimi: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    
    var secilenisim = ""
    
    
    let names = ["Ahmet", "test@gmail.com","emirsecer@gmail.com","Mehmet", "Emir", "Emre", "Fatma", "Serhat", "Şükran", "Tülay", "Ufuk", "Önder", "Eren", "Alp", "Meryem", "Nisa", "İbrahim","ayşe", "merve","hatice","zehra","nuray","alper","adnan ","safa","onur","necmettin","recep","ensar","yaren","gül"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenisim  = names[indexPath.row]
        performSegue(withIdentifier: "tomesajyontemivc", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tomesajyontemivc"  {
            if let destinationvc = segue.destination as? ViewControllermsjyontemi {
                destinationvc.secilenkisi = secilenisim
            }
        }
    }
    @IBAction func messagestartbutton(_ sender: Any) {
    }
}

