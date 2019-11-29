//
//  ViewController.swift
//  SoundBeats
//
//  Created by 2020-1 on 11/27/19.
//  Copyright © 2019 Abstergo. All rights reserved.
//
//  Chávez Espinosa Noah Iván
//
//  Map icon icon by Icons8 https://icons8.com/icons/set/map
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    
    var latitud: CLLocationDegrees!
    var longitud: CLLocationDegrees!
    
    @IBOutlet weak var mapa: MKMapView!
    
    @IBOutlet weak var velocidad: UILabel!
    
    var llendo: Bool = false
    
    var i: Int = 0
    var temporal: [Double] = [0.0]
    var velocidadPromedio: Double = 0.0
    
    var coord: CLLocation!
    var distancia: Double = 0.0
    
    @IBOutlet weak var promedio: UILabel!
    
    @IBOutlet weak var boton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        mapa.delegate = self
        mapa.showsUserLocation = true
        
        coord = locationManager.location
        
        velocidad.backgroundColor = .white
        velocidad.textColor = .blue
        
        promedio.backgroundColor = .white
        promedio.textColor = .darkGray
        promedio.text = " Velocidad Promedio:\n  - m/s\n Distancia:\n  - m"
        
        boton.text = "Inicio"
        boton.textColor = .white
        
        tabBarItem.badgeValue = nil
        tabBarItem.badgeColor = .red
        
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
        
        velocidad.text = String(format: "Velocidad:\n %.2f m/s", locationManager.location!.speed)
        
        var temp: Double = 0.0
        for j in 0...temporal.count-1 {
            temp = temp + temporal[j]
        }
        
        var tempD: Double = 0.0
        
        tempD = (locationManager.location?.distance(from: coord) ?? 0.0)
        
        if llendo {
            //-----------------------------------------------------
            //Trazando la ruta
            let ruta = EndPoints()
            let actual = locationManager.location
            
            ruta.coordinate = CLLocationCoordinate2D(latitude: (actual?.coordinate.latitude)!, longitude: (actual?.coordinate.longitude)!)
            
            ruta.title = ""
            ruta.imageURL = "hexagono-rojo.png"
            
            mapa.addAnnotation(ruta)
            //-----------------------------------------------------
            //Calcular la velocidad promedio
            i = i + 1
            velocidadPromedio = temp/Double(temporal.count-1)
            
            temporal.append(locationManager.location!.speed)
            //-----------------------------------------------------
            //Calculando la distancia
            coord = locationManager.location
            distancia = distancia + tempD
            
        }
        
        if temporal.count > 2 {
            promedio.text = String(format: " Velocidad Promedio:\n  %.2f m/s\n Distancia:\n  %.2f m", velocidadPromedio, distancia)
            print(tempD)
        }
        print(tempD)
        
    }
    
    @IBAction func Iniciar(_ sender: Any) {
        let actual = locationManager.location
        
        let inicio = EndPoints()
        inicio.coordinate = CLLocationCoordinate2D(latitude: (actual?.coordinate.latitude)!, longitude: (actual?.coordinate.longitude)!)
        
        inicio.title = "Inicio"
        inicio.imageURL = "target2.png"
        //Target icon icon by Icons8 https://icons8.com/icons/set/target
        
        mapa.addAnnotation(inicio)
        
        llendo = true
        
        coord = actual

        //Cambiar el color de la label 'promedio'
        promedio.backgroundColor = .cyan
        promedio.textColor = .darkGray
        
        //Cambiar el texto del boton 'Inicio/Continuar'
        boton.text = "Continuar"
        
        tabBarItem.badgeValue = ""
        tabBarItem.badgeColor = .green
        
    }
    
    @IBAction func Detener(_ sender: Any) {
        let actual = locationManager.location
        
        let final = EndPoints()
        final.coordinate = CLLocationCoordinate2D(latitude: (actual?.coordinate.latitude)!, longitude: (actual?.coordinate.longitude)!)
        
        final.title = "Inicio"
        final.imageURL = "target.png"
        //Target icon icon by Icons8 https://icons8.com/icons/set/target

        mapa.addAnnotation(final)
        
        llendo = false
        
        promedio.backgroundColor = .orange
        promedio.textColor = .blue
        
        //Cambiar el texto del boton 'Inicio/Continuar'
        boton.text = "Continuar"
        
        tabBarItem.badgeValue = ""
        tabBarItem.badgeColor = .red
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        var EndPointsAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "EndPointsAnnotationView")
        
        if EndPointsAnnotationView == nil{
            EndPointsAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "EndPointsAnnotationView")
            EndPointsAnnotationView?.canShowCallout = true
        }else{
            EndPointsAnnotationView?.annotation = annotation
        }
        
        if let coffeeAnnotation = annotation as? EndPoints{
            EndPointsAnnotationView?.image = UIImage(named: coffeeAnnotation.imageURL)
        }
        
        return EndPointsAnnotationView
    }
    
    @IBAction func reset(_ sender: Any) {
        promedio.text = " Velocidad Promedio:\n  - m/s\n Distancia:\n  - m"
        
        coord = locationManager.location
        
        i = 0
        temporal = [0.0]
        velocidadPromedio = 0.0
        distancia = 0.0
        
        promedio.backgroundColor = .cyan
        promedio.textColor = .darkGray
        
        //Cambiar el texto del boton 'Inicio/Continuar'
        boton.text = "Inicio"
        
        if !llendo {
            tabBarItem.badgeValue = nil
            tabBarItem.badgeColor = .red
        }
        
    }
    
}

