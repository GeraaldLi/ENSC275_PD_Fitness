//
//  PlannnedTasksAddBtn.swift
//  PD Fitness
//
//  Created by 李超然 on 2019-11-02.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit

class PlannedTasksAddBtn: UIButton {

     required init() {
           super.init(frame: .zero)
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
       
       override func draw(_ rect: CGRect) {
           super.draw(rect)
           layer.cornerRadius = self.frame.height / 2
           clipsToBounds = true
       }
}
