//
//  Neck.swift
//  PD Fitness
//
//  Created by Soroush Saheb-Pour Lighvan  on 2019-10-28.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
//library for youtube video
import youtube_ios_player_helper

class Neck: UIViewController {

    @IBOutlet weak var PlayerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Youtube video with chin tucks
        PlayerView.load(withVideoId: "1v9e8PdmqEI")

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
