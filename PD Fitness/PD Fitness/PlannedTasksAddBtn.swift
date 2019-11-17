//
//  PlannedTasksAddBtn.swift
//  PD Fitness
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs: N/A
//
//  Codes Referenced to:
//  https://www.youtube.com/watch?v=MC4mDQ7UqEE, Sean Allen
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
