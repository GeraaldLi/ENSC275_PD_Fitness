//
//  Calf Raises.swift
//  PD Fitness
//
//  Created by Soroush Saheb-Pour Lighvan  on 2019-11-01.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
//library for youtube video
import youtube_ios_player_helper

class Calf_Raises: UIViewController {

    @IBOutlet weak var PlayerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayerView.load(withVideoId: "VGq8YzBsrjw")
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
