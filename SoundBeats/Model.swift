//
//  Model.swift
//  SoundBeats
//
//  Created by 2020-1 on 11/29/19.
//  Copyright © 2019 Abstergo. All rights reserved.
//
//  Chávez Espinosa Noah Iván
//

import UIKit

struct Resultados: Codable{
    var tempo: [Track]
}

struct Track: Codable {
    var song_title: String
    var artist: Artist
    var album: Album
}

struct Artist: Codable {
    var name: String
    //var img: String
}

struct Album: Codable {
    var title: String
}

