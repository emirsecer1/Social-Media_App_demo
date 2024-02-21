//
//  feedViewController.swift
//  deneme2
//
//  Created by Emir Seçer on 9.09.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import SDWebImage



class ViewControlleranasayfa: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableviewanasayfa: UITableView!
    
    var postdizisi = [post]()
    /*
    var emaildizisi = [String]()
    var gorseldizisi = [String]()
    var yorumdizisi = [String]()
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewanasayfa.delegate = self
        tableviewanasayfa.dataSource = self
        firebaseverilerial()
        
    }
    
    
    func firebaseverilerial () {
        let firestoreDb = Firestore.firestore()
        
        firestoreDb.collection("Post").order(by: "tarih", descending:  true)
            .addSnapshotListener { [self] snapshot , error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    //self.emaildizisi.removeAll(keepingCapacity: false)
                    //self.gorseldizisi.removeAll(keepingCapacity: false)
                    // self.yorumdizisi.removeAll(keepingCapacity: false)
                    self.postdizisi.removeAll(keepingCapacity: false)
                    
                    for  document in snapshot!.documents {
                        if let gorselurl = document.get("gorselurl") as? String{
                            if let yorum = document.get("yorum") as? String {
                                if let email = document.get("email") as? String {
                                    
                                    let post = post(email: email, yorum: yorum, gorselurl: gorselurl)
                                    self.postdizisi.append(post)
                                    
                                }
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                            
                            
                            self.tableviewanasayfa.reloadData()
                            
                        }
                        
                    }
                        
                    }
                }
            }
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return postdizisi.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableviewanasayfa.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedcell
            cell.epostatext.text = postdizisi[indexPath.row].email
            cell.yorumtext.text = postdizisi[indexPath.row].yorum
            cell.cellimage.sd_setImage(with: URL(string: self.postdizisi[indexPath.row].gorselurl))
            
            return cell
        }
        
        
        
    }
    
    


