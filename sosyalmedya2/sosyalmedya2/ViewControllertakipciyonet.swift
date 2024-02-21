import UIKit
import CoreData

class ViewControllertakipciyonet: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedname = ""
    var secilenisim  = ""
    @IBOutlet weak var tableview: UITableView!
    
    var names = ["Ahmet", "Mehmet", "Emir", "Emre", "Fatma", "Serhat", "Şükran", "Tülay", "Ufuk", "Önder", "Eren", "Alp", "Meryem", "Nisa", "İbrahim","ayşe", "merve","hatice","zehra","nuray","alper","adnan ","safa","onur","necmettin","recep","ensar","yaren","gül"]
    
    var kisidizisi = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the data source and delegate of the table view to this view controller
        tableview.dataSource = self
        tableview.delegate = self
        
        verilerial()
    }
    
    func verilerial() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "Rehber")
        fetchrequest.returnsObjectsAsFaults = false
        do {
            let sonuclar = try context.fetch(fetchrequest)
            for sonuc in sonuclar {
                if let isim = sonuc.value(forKey: "kisi") as? String {
                    kisidizisi.append(isim)
                }
            }
            tableview.reloadData()
        } catch {
            print("Veri alınırken hata oluştu: \(error)")
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = names[indexPath.row]
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform the segue when a cell is selected
        performSegue(withIdentifier: "kisiyonettokisisayfa", sender: indexPath.row)
    }
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kisiyonettokisisayfa" {
            let dest = segue.destination as! ViewControllermsjyontemi
            dest.secilenkisi = selectedname
        }
        if segue.identifier == "kisiyonettokisisayfa"{
            let destination  = segue.destination as! ViewControllermsjyontemi
            destination.secilenkisi = secilenisim
        }
    }
    
    // MARK: - Swipe to Delete
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { (action, view, completionHandler) in
            let nameToDelete = self.names[indexPath.row]
            self.names.remove(at: indexPath.row) // Remove from the names array
            tableView.deleteRows(at: [indexPath], with: .fade) // Remove from the table view
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // MARK: - Follow Button Action
    
    @objc func followButtonTapped(_ sender: UIButton) {
        let selectedName = names[sender.tag]
        // Perform follow action here based on selectedName
        // For example, you can show an alert indicating successful follow
        let alert = UIAlertController(title: "Takip Edildi", message: "Şimdi \(selectedName) adlı kişiyi takip ediyorsunuz.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
        // Core Data'ya kişiyi ekle
        veriEkle(isim: selectedName)
    }
    
    // MARK: - Veri Ekleme
    
    func veriEkle(isim: String) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Rehber", in: context)
        let yeniKisi = NSManagedObject(entity: entity!, insertInto: context)
        yeniKisi.setValue(isim, forKey: "kisi")
        
        do {
            try context.save()
            kisidizisi.append(isim)
            tableview.reloadData()
        } catch {
            print("Veri eklenirken hata oluştu: \(error)")
        }
    }
}

