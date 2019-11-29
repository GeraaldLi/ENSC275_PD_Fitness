//
//  Neck.swift
//  Team: PD Fitness
//  Programmers: Soroush Saheb-Pour Lighvan
//  Known Bugs: youtube_ios_player_helper library is depreceated since IOS 12
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
//library for youtube video
import youtube_ios_player_helper

class Neck: UIViewController {
    
    var count : Int = 0;
    @IBOutlet weak var label: UILabel!
    //player view for youtube video
    @IBOutlet weak var PlayerView: YTPlayerView!
    @IBAction func minus(_ sender: UIButton) {
        count = count - 1;
        label.text = String(count);
        
    }
    @IBAction func add(_ sender: UIButton) {
        count = count + 1;
        label.text = String(count);
        
    }
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
