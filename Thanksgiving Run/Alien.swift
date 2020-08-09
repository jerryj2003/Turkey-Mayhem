//
//  Alien.swift
//  Thanksgiving Run
//
//  Created by Jerry Ji on 4/1/19.
//  Copyright © 2019 Jerry Ji. All rights reserved.
//

import UIKit
import SpriteKit

class Alien: SKSpriteNode {
    //property indicating whether aliens come from left or right
    var isLeft = true
    func move() {
        if isLeft{
            self.position.x += 5.5
        } else {
            self.position.x -= 5.5
        }
    }
}
