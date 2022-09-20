//
//  YTServices.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/09/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class YTServices{
    static let shared: YTServices = YTServices()
    
    //MARK: GET PLAYLIST
    func getPlayList(params: [String:Any], completion: @escaping (_ response: ResponsePlayListItems?)->()){
        AF.request(PLAYLIST_ITEMS, method: .get, parameters: params, encoding: URLEncoding.default, headers: AuthServices.shared.header).response{
            response in
            
            guard let data = response.data else {
                print("Hell, NO Data")
                print("Here is the RESPONSE :", response)
                completion(nil)
                return
            }
            let json = JSON(data)
            print("JSON getPlayList: ", json)
//            let statusCode = json["statusCode"].intValue
//            let message = json["message"].stringValue
//
            do{
                let parsedData = try JSONDecoder().decode(ResponsePlayListItems.self, from: data)
                completion(parsedData)
            }catch let e{
                print("Hell, Unable to parse JSON")
                print("Here is the error :", e)
                completion(nil)
            }
        }
    }
}
