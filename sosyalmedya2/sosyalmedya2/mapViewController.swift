import UIKit
import MapKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import CoreLocation

class mapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapview: MKMapView!
    var locationmaneger = CLLocationManager()
    var secilenlatitude = Double()
    var secilenlongitude = Double()
    var secilenisim = ""
    var secilenId = ""
    
    var annotiontitle = ""
    var annotionsubtitle = ""
    var anootionlatitude = Double()
    var annotionlongitude = Double()
    
    let db = Firestore.firestore()
    var placesCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapview.delegate = self
        
        locationmaneger.delegate = self
        locationmaneger.desiredAccuracy = kCLLocationAccuracyBest
        locationmaneger.requestWhenInUseAuthorization()
        locationmaneger.startUpdatingLocation()
        
        placesCollectionRef = db.collection("haritalar") // Firestore koleksiyonunu belirtin
        
        // Firestore'dan verileri al
        fetchMapLocations()
        
        let gesturerecognizer = UILongPressGestureRecognizer(target: self, action: #selector(konumSec(gestureRecognizer:)))
        gesturerecognizer.minimumPressDuration = 3
        mapview.addGestureRecognizer(gesturerecognizer)
    }
    
    // Firestore'dan verileri çekme
    func fetchMapLocations() {
        placesCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching map locations: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            // Haritada bulunan mevcut pinleri temizle
            self.clearMapAnnotations()
            
            for document in documents {
                if let latitude = document.get("latitude") as? Double,
                   let longitude = document.get("longitude") as? Double,
                   let title = document.get("title") as? String,
                   let subtitle = document.get("subtitle") as? String {
                    // Firestore'dan çekilen verileri haritada gösterme
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.title = title
                    annotation.subtitle = subtitle
                    self.mapview.addAnnotation(annotation)
                }
            }
        }
    }
    
    func clearMapAnnotations() {
        let annotations = mapview.annotations
        mapview.removeAnnotations(annotations)
    }
    
    @objc func konumSec(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let dokunulanNokta = gestureRecognizer.location(in: mapview)
            let dokunulanKoordinat = mapview.convert(dokunulanNokta, toCoordinateFrom: mapview)
            
            secilenlatitude = dokunulanKoordinat.latitude
            secilenlongitude = dokunulanKoordinat.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = dokunulanKoordinat
            mapview.addAnnotation(annotation)
            
            // Yeni konumu Firestore'a kaydetme
            saveLocationToFirestore(latitude: secilenlatitude, longitude: secilenlongitude, title: "Başlık", subtitle: "Alt Başlık")
            
            // Firestore'dan verileri güncelleme
            fetchMapLocations()
        }
    }
    
    // Firestore'a yeni konumu kaydetme
    func saveLocationToFirestore(latitude: Double, longitude: Double, title: String, subtitle: String) {
        let locationData: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
            "title": title,
            "subtitle": subtitle
        ]
        
        placesCollectionRef.addDocument(data: locationData) { error in
            if let error = error {
                print("Error adding document to Firestore: \(error)")
            } else {
                print("Document added to Firestore")
            }
        }
    }
}

