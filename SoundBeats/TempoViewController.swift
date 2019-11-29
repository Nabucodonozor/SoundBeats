//
//  TempoViewController.swift
//  SoundBeats
//
//  Created by 2020-1 on 11/29/19.
//  Copyright © 2019 Abstergo. All rights reserved.
//
//  Chávez Espinosa Noah Iván
//
//  Metronome icon icon by Icons8 https://icons8.com/icons/set/tempo
//
//  Datos de canciones proporcionados por getsongbpm.com
//

import UIKit

class TempoViewController: UIViewController, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var trackList: [Track] = []
    @IBOutlet weak var tabla: UITableView!
    
    var arreglo: [String] = ["40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "159", "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171", "172", "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "192", "193", "194", "195", "196", "197", "198", "199", "200", "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216", "217", "218", "219", "220"]
    
    @IBOutlet weak var picker: UIPickerView!
    var ritmo: String = ""
    
    @IBOutlet weak var buscando: UILabel!
    @IBOutlet weak var titulo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.dataSource = self
        //getTracks(bpm: "175")
        self.tabla.rowHeight = 80
        
        picker.dataSource = self
        picker.delegate = self
        
        ritmo = arreglo[135]
        print("Override: \(ritmo)")
        getTracks(bpm: ritmo)
        
        buscando.text = ""
        buscando.textColor = .black
        
        titulo.text = "\tCanciones a \(ritmo) bpm"

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        let track = trackList[indexPath.row]
        
        cell.textLabel?.numberOfLines = 5
        
        cell.textLabel!.text = "'\(track.song_title)'\n\t- \(track.artist.name)"
        //cell.textLabel!.text = "\(track.artist.img)"
        
        cell.imageView?.image = UIImage(named: "mapa")
        
        buscando.text = "¡Listo!"
        buscando.textColor = .black
        
        cell.backgroundColor = .lightGray
        
        titulo.text = "\tCanciones a \(ritmo) bpm"
        
        return cell
    }
    
    func getTracks(bpm: String){
        //Datos de canciones proporcionados por getsongbpm.com
        let url = URL(string: "https://api.getsongbpm.com/tempo/?api_key=f16f10ced954e7c1d315892f34ec8763&bpm=\(bpm)")
        //Llave que pedí
        let jsonDecoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            if let datos = data, let contenido = try? jsonDecoder.decode(Resultados.self, from: datos) {
                let tracksListTemp = contenido.tempo
                self.trackList.removeAll()
                for track in tracksListTemp {
                    print(track.song_title)
                    self.trackList.append(track)
                }
                
                DispatchQueue.main.async {
                    self.tabla.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arreglo.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(arreglo[row]) bpm"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ritmo = arreglo[row]
        
        print("\nBPM: \(ritmo)")
        
        buscando.text = "Buscando..."
        buscando.textColor = .darkGray
        
        getTracks(bpm: ritmo)
    }
    

}
