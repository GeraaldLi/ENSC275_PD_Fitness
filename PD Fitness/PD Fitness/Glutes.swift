//
//  Glutes.swift
//  Team: PD Fitness
//  Programmers: Soroush Saheb-Pour Lighvan
//  Known Bugs: youtube_ios_player_helper library is depreceated since IOS 12
//

import UIKit
//library needed for youtube
import youtube_ios_player_helper

class Glutes: UIViewController {
    // viewplayer youtube
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //exercise video
       playerView.load(withVideoId: "7ZQqU0QFB5w")
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
