//
//  MusicItemTVC.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/08/2022.
//

import UIKit

class MusicItemTVC: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var title: String? {
        didSet{
            titleLbl.text = title
        }
    }
    var userName: String?{
        didSet{
            userLbl.text = userName
        }
    }
    var imageUrl: String?{
        didSet{
            Utilities.shared.setImageFromUrl(imgView: imgView, url: imageUrl ?? "")
        }
    }
    var time: String?{
        didSet{
            lblTime.text = time
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(_ item: Item?){
        guard let item = item else {
            return
        }
        title = item.snippet.title
        userName = item.snippet.videoOwnerChannelTitle
        imageUrl = item.snippet.thumbnails.thumbnailsDefault?.url
        time = item.snippet.publishedAt.timeAgoFromString()
    }
    
}
