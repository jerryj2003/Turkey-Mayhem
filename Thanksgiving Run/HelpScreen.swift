//
//  HelpScreen.swift
//  Thanksgiving Run
//
//  Created by Jerry Ji on 11/24/19.
//  Copyright © 2019 Jerry Ji. All rights reserved.
//

import UIKit
import SpriteKit

class HelpScreen: SKScene {
    override func didMove(to view: SKView) {
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if touchedNode.name == "backButton"{
            if let view = self.view {
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    // Present the scene
                    view.presentScene(scene)
                }
            }
        }
    }
}

