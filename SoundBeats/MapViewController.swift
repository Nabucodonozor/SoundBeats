//
//  ViewController.swift
//  SoundBeats
//
//  Created by 2020-1 on 11/27/19.
//  Copyright © 2019 Abstergo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    
    var latitud: CLLocationDegrees!
    var longitud: CLLocationDegrees!
    
    @IBOutlet weak var mapa: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        mapa.delegate = self
        mapa.showsUserLocation = true
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first!)
        
        print(locationManager.location!.speed)
        
        if let localidad = locations.first{
            latitud = localidad.coordinate.latitude
            longitud = localidad.coordinate.longitude
            
            let localizacion = CLLocationCoordinate2DMake(latitud, longitud)
            let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            let region = MKCoordinateRegion(center: localizacion, span: span)
            
            mapa.setRegion(region, animated: true)
            mapa.mapType = .standard
        }
        
    }
    @IBAction func Iniciar(_ sender: Any) {
        //locationManager.startUpdatingLocation()
        //locationManager.startUpdatingHeading()

        
        let actual = locationManager.location
        
        let inicio = EndPoints()
        //let inicio = MKPointAnnotation()
        inicio.coordinate = CLLocationCoordinate2D(latitude: (actual?.coordinate.latitude)!, longitude: (actual?.coordinate.longitude)!)
        //inicio.coordinate = CLLocationCoordinate2D(latitude: 19.3275, longitude: -99.1824)
        
        inicio.title = "Inicio"
        inicio.imageURL = "target2.png"
        //Target icon icon by Icons8 https://icons8.com/icons/set/target
        
        mapa.addAnnotation(inicio)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        var InicioAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "InicioAnnotationView")
        
        if InicioAnnotationView == nil{
            InicioAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "InicioAnnotationView")
            InicioAnnotationView?.canShowCallout = true
        }else{
            InicioAnnotationView?.annotation = annotation
        }
        
        if let coffeeAnnotation = annotation as? EndPoints{
            InicioAnnotationView?.image = UIImage(named: coffeeAnnotation.imageURL)
        }
        
        return InicioAnnotationView
    }
    
    //Target icon icon by Icons8 https://icons8.com/icons/set/target

}

