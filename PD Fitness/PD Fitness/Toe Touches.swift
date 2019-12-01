//
//  Toe Touches.swift
//  PD Fitness
//
//  Created by Soroush Saheb-Pour Lighvan  on 2019-11-30.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class Toe_Touches: UIViewController {
    
    var count : Int = 0;
    
    @IBOutlet weak var label: UILabel!
    @IBAction func minus(_ sender: UIButton) {
        count = count - 1;
        label.text = String(count);
        
    }
    
    @IBAction func add(_ sender: UIButton) {
        count = count + 1;
        label.text = String(count);
    }
    @IBOutlet weak var PlayerView: YTPlayerView!
    override func viewDidLoad() {
        
        PlayerView.load(withVideoId: "Xvr5N_Xf6QM")
        super.viewDidLoad()

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
