//
//  GlobalConstants.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/08/2022.
//

import Foundation

let BASE_URL = "https://youtube.googleapis.com/youtube/v3/"
let PLAYLIST_ITEMS = BASE_URL + "playlistItems"

enum Cell: String {
    case musicItem = "MusicItemTVC"
}

enum LocalKeys: String{
    case keyLoginToken
    case keyIsLoggedIn
    case keyPlaylistId
}

let playerVars:[String: Any] = [
    "autoplay": "1",
    "controls" : "0",
    "modestbranding": "1",
    "iv_load_policy" : "3",
    "playsinline" : "1"
]
