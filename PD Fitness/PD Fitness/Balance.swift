//
//  Balance.swift
//  PD Fitness
//
//  Created by Soroush Saheb-Pour Lighvan  on 2019-10-28.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
//library needed for youtube embedding
import youtube_ios_player_helper


class Balance: UIViewController {
    //playerview object linked to file
    @IBOutlet weak var PlayerView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load youtube video for balance
        PlayerView.load(withVideoId: "vopR7e8kECY")
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
