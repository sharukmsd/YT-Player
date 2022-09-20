//
//  Utilties.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/09/2022.
//

import Foundation
import SDWebImage
import UIKit

class Utilities{
    static let shared: Utilities = Utilities()
    func setImageFromUrl(imgView: UIImageView, url: String, placeholder: UIImage = UIImage(named: "img")!){
        print("URL OF IMAGE ", url)
//        if url.contains("http"){
            imgView.sd_setImage(with: URL(string: url), placeholderImage: placeholder)
//        }else{
//            imgView.sd_setImage(with: URL(string: BASE_FOR_IMAGE + url), placeholderImage: placeholder)
//
//        }
    }
}
