//
//  Squats.swift
//  PD Fitness
//
//  Created by Soroush Saheb-Pour Lighvan  on 2019-11-01.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
//library for youtube video
import youtube_ios_player_helper

class Squats: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Youtube video with chin tucks
        playerView.load(withVideoId: "inegQ48dV_Y")
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
