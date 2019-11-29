//
//  Shoulder Look.swift
//  PD Fitness
//
//  Created by Soroush Saheb-Pour Lighvan  on 2019-11-14.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
//Library for youtube ios player
import youtube_ios_player_helper

class Shoulder_Look: UIViewController {
    
    var count : Int = 0;
    
    @IBOutlet weak var PlayerView: YTPlayerView!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func add(_ sender: UIButton) {
        count = count + 1;
        label.text = String(count);
        
    }
    @IBAction func minus(_ sender: UIButton) {
        count = count - 1;
        label.text = String(count);
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayerView.load(withVideoId: "0-7kmLMLW7o")

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
