//
//  String.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/09/2022.
//

import Foundation
extension String{
    func timeAgoFromString() -> String{
        //set time ago
        let string = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_PK") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z"

        if let date = dateFormatter.date(from: string){
            let timeAgo = date.timeAgoDisplay()
            print("date---------", date)
            return timeAgo
        }else{
            return ""
        }
    }
}
