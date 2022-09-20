//
//  ViewController.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/08/2022.
//



import UIKit
import Alamofire
import youtube_ios_player_helper_swift
import GoogleAPIClientForREST
import GoogleSignIn


class VCHome: UIViewController {
    //MARK: Properties
    var respnseItems: ResponsePlayListItems? = nil
//    var isPlaying = false
    var selectedIndex = 0
    var videoPlayer = YTPlayerView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))

    var plistId = AuthServices.shared.playlistId
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var tbImgView: UIImageView!
    @IBOutlet weak var tbLblName: UILabel!
    @IBOutlet weak var nameImgButton: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnNext: UIButton!

    
    //MARK: App LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //searchbar
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.musicItem.rawValue, bundle: nil), forCellReuseIdentifier: Cell.musicItem.rawValue)
        

        tbImgView.layer.cornerRadius = tbImgView.frame.height/2
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        upSwipe.direction = [.up]
        toolBar.addGestureRecognizer(upSwipe)
        
        self.view.addSubview(videoPlayer)
        videoPlayer.isHidden = true
        videoPlayer.delegate = self
        
        getData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: .none)
        
        if videoPlayer.playerState == .playing{
            btnPlayPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }else{
            btnPlayPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }

    }
    fileprivate func getData() {
        let params = [
            "part" : "snippet",
            "playlistId" : plistId,
            "maxResults" : 50
        ] as [String : Any]
        print("params :", params)
        YTServices.shared.getPlayList(params: params, completion: {
            response in
            if let parsedResponse = response{
                print("parsedResponse", parsedResponse)
                self.respnseItems = parsedResponse
                var reversedItems: [Item] = []
                for arrayIndex in stride(from: (self.respnseItems?.items.count ?? 0) - 1, through: 0, by: -1) {
                    if let item = self.respnseItems?.items[arrayIndex]{
                        reversedItems.append(item)
                    }
                }
                self.respnseItems?.items = reversedItems
                self.tableView.reloadData()
            }else{
                print("Data is nil")
            }
        })
    }
    
    @objc func handleSwipes(_ sender: UIToolbar){
        openPlayer()
    }
    fileprivate func openPlayer(){
        let playerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCPlayer") as! VCPlayer
        playerVC.items = respnseItems?.items ?? []
        playerVC.selectedIndex = selectedIndex
        playerVC.videoPlayer = videoPlayer
        playerVC.delegate = self
        navigationController?.present(playerVC, animated: true, completion: nil)
    }
    @IBAction func newPlayListTapped(_ sender: UIBarButtonItem) {
        let inputAlert = UIAlertController(title: "Add playlist", message: "Please enter link of your youtube playlist", preferredStyle: .alert)
        inputAlert.addTextField{
            (tf) in
            tf.placeholder = "Playlist link"
        }
        inputAlert.addAction(UIAlertAction(title: "Fetch", style: .default, handler: {
            [weak inputAlert] (_) in
            let textField = inputAlert?.textFields![0]
            print("textField.text", textField?.text ?? "")
            if let link = textField?.text{
                if link.contains("https://youtube.com/playlist?list="){
                    self.plistId = link.replacingOccurrences(of: "https://youtube.com/playlist?list=", with: "")
                }else{
                    self.plistId = link.replacingOccurrences(of: "https://www.youtube.com/playlist?list=", with: "")
                }
                AuthServices.shared.playlistId = self.plistId
                self.getData()
            }
        }))
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(inputAlert, animated: true, completion: nil)
    }
    

    @IBAction func toolBarTapped(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func playPausedPressed(_ sender: UIButton) {
        if videoPlayer.playerState == .playing{
            videoPlayer.pauseVideo()
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }else{
            videoPlayer.playVideo()
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @IBAction func nextTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
    }
    @IBAction func nameOrImgTapped(_ sender: UIButton) {
        print("toolbar tapped")
        openPlayer()
    }
    
}
//MARK: TableView Config
extension VCHome: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.musicItem.rawValue, for: indexPath) as! MusicItemTVC

        cell.configureWith(respnseItems?.items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return respnseItems?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)

        tbLblName.text = respnseItems?.items[indexPath.row].snippet.title
        Utilities.shared.setImageFromUrl(imgView: tbImgView, url: respnseItems?.items[indexPath.row].snippet.thumbnails.high?.url ?? "")
        selectedIndex = indexPath.row

        if videoPlayer.playerState == .playing{
            videoPlayer.stopVideo()
            btnPlayPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        
        _ = videoPlayer.load(videoId: respnseItems?.items[indexPath.row].snippet.resourceID.videoID ?? "", playerVars: playerVars)
    }
}
//MARK: Search Results Controller
extension VCHome: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            print(text)
            //                   self.filtered = self.countries.filter({ (country) -> Bool in
            //                       return country.lowercased().contains(text.lowercased())
            //                   })
            //                   self.filterring = true
        }
        else {
            //                   self.filterring = false
            //                   self.filtered = [String]()
        }
        //               self.table.reloadData()
    }


}
extension VCHome: YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
        btnPlayPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        print("Quality :: ", quality)
    }
    
    //    func playerViewPreferredInitialLoadingView(_ playerView: YTPlayerView) -> UIView? {
    //        let loader = UIView(frame: CGRect(x: 10, y: 10, width: 200, height: 200))
    //        loader.backgroundColor = UIColor.brown
    //        return loader
    //    }
}
extension VCHome: PlayerDelegate{
    func stateOfPlayer(index: Int, player: YTPlayerView) {
        self.selectedIndex = index
        self.videoPlayer = player
    }
    
    
}
