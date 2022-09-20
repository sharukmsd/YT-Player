//
//  AuthServices.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/09/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthServices{
    static let shared: AuthServices = AuthServices()
    
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: LocalKeys.keyLoginToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LocalKeys.keyLoginToken.rawValue)
        }
    }
    
    var header: HTTPHeaders{
        get{
            return ["Authorization": "Bearer \(token)", "Accept": "application/json"]
        }
    }
    var isLoggedIn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: LocalKeys.keyIsLoggedIn.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LocalKeys.keyIsLoggedIn.rawValue)
        }
    }
    var playlistId: String {
        get {
            return UserDefaults.standard.string(forKey: LocalKeys.keyPlaylistId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: LocalKeys.keyPlaylistId.rawValue)
        }
    }

}
