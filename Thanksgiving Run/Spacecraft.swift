//
//  Spacecraft.swift
//  Thanksgiving Run
//
//  Created by Jerry Ji on 1/2/20.
//  Copyright © 2020 Jerry Ji. All rights reserved.
//

import UIKit
import SpriteKit

class Spacecraft: SKSpriteNode {
    //property indicating whether spacecrafts come from left or right
    var isLeft = true
    func move() {
        if isLeft{
            self.position.x += 5.5
        } else {
            self.position.x -= 5.5
        }
    }
}
