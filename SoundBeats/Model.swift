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
    var song_id: String
    var song_title: String
    var song_uri: String
    var tempo: String
    var artist: Artist
    var album: Album
}

struct Artist: Codable {
    var id: String
    var name: String
    var uri: String
    var mbid: String
}

struct Album: Codable {
    var title: String
    var uri: String
    //var img: String//*
    var year: String
}

