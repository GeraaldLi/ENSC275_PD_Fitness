//
//  Balance_2.swift
//  PD Fitness
//
//  Created by Soroush Saheb-Pour Lighvan  on 2019-11-14.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
//library needed for youtube embedding
import youtube_ios_player_helper

class Balance_2: UIViewController {
    //view player
    var count : Int = 0;
    
    @IBOutlet weak var label: UILabel!
    @IBAction func minus_button(_ sender: Any) {
        count = count - 1;
        label.text = String(count);
    
    }
    @IBAction func add_button(_ sender: UIButton) {
        count = count + 1;
        label.text = String(count);
    }
    @IBOutlet weak var PlayerView: YTPlayerView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        PlayerView.load(withVideoId: "UQ6-7TrmKxU")
        //youtube video with ID
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
