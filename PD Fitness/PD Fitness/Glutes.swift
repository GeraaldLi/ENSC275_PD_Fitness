//
//  Glutes.swift
//  
//
//  Created by Soroush Saheb-Pour Lighvan  on 2019-10-27.
//

import UIKit
//import YoutubePlayer_in_WKWebView
import youtube_ios_player_helper

class Glutes: UIViewController {

//    @IBOutlet weak var playerView: WKYTPlayerView!
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sample video
       playerView.load(withVideoId: "AiKOvoRFOCM")
//        playerView.load(withVideoId: "AiKOvoRFOCM")
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
