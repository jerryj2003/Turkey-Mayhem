//
//  GameScene.swift
//  Thanksgiving Run
//
//  Created by Jerry Ji on 11/18/18.
//  Copyright © 2018 Jerry Ji. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player : SKSpriteNode?
    
    var bg1 : SKSpriteNode?
    var bg2 : SKSpriteNode?
    
    var bullet1 : SKSpriteNode?
    var bullet2 : SKSpriteNode?
    var bullets = [SKSpriteNode]()
    
    var alien : Alien?
    var alienTextures = [SKTexture]()
    var alienTexture = SKTexture(image: UIImage(named:"alien (1)")!)
    
    var spacecraft : Spacecraft?
    var spacecraftTextures = [SKTexture]()
    var spacecraftTexture = SKTexture(image: UIImage(named:"spacecraft1")!)
    
    var ground : SKSpriteNode?
    
    var bomb : SKSpriteNode?
    var bombArray = [SKSpriteNode]()
    
    var sbullet : SKSpriteNode?
    var sbulletArray = [SKSpriteNode]()
    
    var explosion : SKSpriteNode?
    var explosionTextures = [SKTexture]()
    
    var title : SKSpriteNode?
    var playButton : SKSpriteNode?
    var helpButton : SKSpriteNode?
    var achievementButton : SKSpriteNode?
    
    
    let playerCategory : UInt32 = 0x1 << 1
    
    let projectileCategory : UInt32 = 0x1 << 2
    
    let bulletCategory : UInt32 = 0x1 << 3
    
    let alienCategory : UInt32 = 0x1 << 5
    
    let spacecraftCategory : UInt32 = 0x1 << 6
    
    
    
    
    var gameStarted = false
    var playerAlive = true
    
    var alienCounter = 0
    var spacecraftCounter = 0
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if (contact.bodyA.categoryBitMask == playerCategory &&
            contact.bodyB.categoryBitMask == projectileCategory) || (contact.bodyA.categoryBitMask == projectileCategory && contact.bodyB.categoryBitMask == playerCategory){
            playerAlive = false
            if contact.bodyB.categoryBitMask == projectileCategory {
                contact.bodyB.node?.removeFromParent()
                createExplosion(pos: player!.position)
                contact.bodyA.node?.removeFromParent()
                bullet1?.removeFromParent()
                bullet2?.removeFromParent()
                
                
            } else {
                contact.bodyA.node?.removeFromParent()
                createExplosion(pos: player!.position)
                contact.bodyB.node?.removeFromParent()
                bullet1?.removeFromParent()
                bullet2?.removeFromParent()
            }
            
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameOver), userInfo: nil, repeats: false)
            
        }
        
        if (contact.bodyA.categoryBitMask == alienCategory &&
            contact.bodyB.categoryBitMask == bulletCategory) || (contact.bodyA.categoryBitMask == bulletCategory && contact.bodyB.categoryBitMask == alienCategory){
            
            if contact.bodyB.categoryBitMask == bulletCategory{
                contact.bodyB.node?.removeFromParent()
                if contact.bodyA.node != nil {
                    createExplosion(pos: contact.bodyA.node!.position)
                    contact.bodyA.node?.removeFromParent()
                    alienCounter += 1
                }
                
            } else {
                contact.bodyA.node?.removeFromParent()
                if contact.bodyB.node != nil {
                    createExplosion(pos: contact.bodyB.node!.position)
                    contact.bodyB.node?.removeFromParent()
                    alienCounter += 1
                }
            }
            
            
        }
        
        if (contact.bodyA.categoryBitMask == spacecraftCategory &&
            contact.bodyB.categoryBitMask == bulletCategory) || (contact.bodyA.categoryBitMask == bulletCategory && contact.bodyB.categoryBitMask == spacecraftCategory){
            
            if contact.bodyB.categoryBitMask == bulletCategory{
                contact.bodyB.node?.removeFromParent()
                if contact.bodyA.node != nil {
                    createExplosion(pos: contact.bodyA.node!.position)
                    contact.bodyA.node?.removeFromParent()
                }
                
            } else {
                contact.bodyA.node?.removeFromParent()
                if contact.bodyB.node != nil {
                    createExplosion(pos: contact.bodyB.node!.position)
                    contact.bodyB.node?.removeFromParent()
                }
            }
            
            
        }
        
    }
    
    
    func animateAlien() {
        alien!.run(SKAction.repeatForever(
            SKAction.animate(with: alienTextures,
                             timePerFrame: 0.2,
                             resize: false,
                             restore: true)),
                   withKey:"alienAnimation")
    }
    
    func animateSpacecraft() {
        spacecraft!.run(SKAction.repeatForever(
            SKAction.animate(with: spacecraftTextures,
                             timePerFrame: 0.2,
                             resize: false,
                             restore: true)),
                        withKey:"spacecraftAnimation")
    }
    
    func createExplosion(pos: CGPoint) {
        let explosion = SKSpriteNode(texture: explosionTextures[0])
        explosion.size = CGSize(width: 325, height: 325)
        self.addChild(explosion)
        explosion.position = pos
        explosion.run(SKAction.sequence([SKAction.animate(with: explosionTextures, timePerFrame: 0.1), SKAction.removeFromParent()]))
        
    }
    
    
    override func didMove(to view: SKView) {
        
        
        physicsWorld.contactDelegate = self
        
        //buttons
        title = self.childNode(withName: "title") as? SKSpriteNode
        playButton = self.childNode(withName: "playButton") as? SKSpriteNode
        helpButton = self.childNode(withName: "helpButton") as? SKSpriteNode
        achievementButton = self.childNode(withName: "achievementButton") as? SKSpriteNode
        
        
        
        //player
        player = self.childNode(withName: "player") as? SKSpriteNode
        player?.size = CGSize(width: 100, height: 100)
        player?.physicsBody?.isDynamic = false
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.contactTestBitMask = projectileCategory
        
        
        //background
        let background = UIImage(named: "TRBackground")
        bg1 = SKSpriteNode(texture : SKTexture(image: background!) )
        bg2 = SKSpriteNode(texture : SKTexture(image: background!) )
        
        bg1 = self.childNode(withName: "background1") as? SKSpriteNode
        bg2 = self.childNode(withName: "background2") as? SKSpriteNode
        
        
        //bullet
        bullet1 = self.childNode(withName: "bullet1") as? SKSpriteNode
        bullet2 = self.childNode(withName: "bullet2") as? SKSpriteNode
        
        bullet1?.physicsBody?.categoryBitMask = bulletCategory
        bullet2?.physicsBody?.categoryBitMask = bulletCategory
        bullet1?.physicsBody?.contactTestBitMask = alienCategory
        bullet2?.physicsBody?.contactTestBitMask = alienCategory
        
        //spacecraft
        spacecraftTextures.append(SKTexture(image: UIImage(named:"spacecraft1")!))
        spacecraftTextures.append(SKTexture(image: UIImage(named:"spacecraft2")!))
        spacecraftTextures.append(SKTexture(image: UIImage(named:"spacecraft3")!))
        spacecraft = self.childNode(withName: "spacecraft") as? Spacecraft
        
        spacecraft!.physicsBody?.collisionBitMask = bulletCategory
        spacecraft!.physicsBody?.categoryBitMask = spacecraftCategory
        spacecraft!.physicsBody?.contactTestBitMask = bulletCategory
        
        
        
        //alien
        alienTextures.append(SKTexture(image: UIImage(named:"alien (1)")!))
        alienTextures.append(SKTexture(image: UIImage(named:"alien (2)")!))
        alienTextures.append(SKTexture(image: UIImage(named:"alien (3)")!))
        alienTextures.append(SKTexture(image: UIImage(named:"alien (4)")!))
        alienTextures.append(SKTexture(image: UIImage(named:"alien (3)")!))
        alienTextures.append(SKTexture(image: UIImage(named:"alien (2)")!))
        
        alien = self.childNode(withName: "alien") as? Alien
        alien?.position = CGPoint(x: -self.frame.width/2 - 50, y: 2000)
        alien?.size = CGSize(width: 75, height: 75)
        
        //explosion
        explosionTextures.append(SKTexture(image: UIImage(named:"explosion0")!))
        explosionTextures.append(SKTexture(image: UIImage(named:"explosion1")!))
        explosionTextures.append(SKTexture(image: UIImage(named:"explosion2")!))
        explosionTextures.append(SKTexture(image: UIImage(named:"explosion3")!))
        explosionTextures.append(SKTexture(image: UIImage(named:"explosion4")!))
        explosionTextures.append(SKTexture(image: UIImage(named:"explosion5")!))
        explosionTextures.append(SKTexture(image: UIImage(named:"explosion6")!))
        
        //ground
        ground = self.childNode(withName: "ground") as? SKSpriteNode
        
        //bomb
        bomb = SKSpriteNode(texture: SKTexture(image: UIImage(named:"bomb")!))
        self.addChild(bomb!)
        bomb?.size = CGSize(width: 65, height: 65)
        bomb?.position = CGPoint(x: 3000, y: self.frame.height/2 + 65)
        bomb?.physicsBody = SKPhysicsBody(texture: SKTexture(image: UIImage(named:"bomb")!), size: CGSize(width: 65, height: 65))
        bombArray.append(bomb!)
        
        bomb?.physicsBody?.categoryBitMask = projectileCategory
        bomb?.physicsBody?.contactTestBitMask = playerCategory
        
        _ = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
        
        //Spacecraft Bullet
        sbullet = SKSpriteNode(texture: SKTexture(image: UIImage(named:"bullet (1)")!))
        self.addChild(sbullet!)
        sbullet?.size = CGSize(width: 40, height: 40)
        sbullet?.position = CGPoint(x: 3000, y: self.frame.height/2 + 65)
        sbullet?.physicsBody = SKPhysicsBody(texture: SKTexture(image: UIImage(named:"bullet (1)")!), size: CGSize(width: 40, height: 40))
               sbulletArray.append(sbullet!)
               
               sbullet?.physicsBody?.categoryBitMask = projectileCategory
               sbullet?.physicsBody?.contactTestBitMask = playerCategory
               
               _ = Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(shoot), userInfo: nil, repeats: true)
    }
    
    func startGame(){
        animateAlien()
        animateSpacecraft()
        
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(dropBomb), userInfo: nil, repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(alienReplication), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(spacecraftReplication), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func dropBomb() { //a is input alien from which bomb is to be dropped
        
        var aliensOnScreen = [SKSpriteNode]()
        
        
        for child in self.children {
            if type(of: child) == Alien.self {
                if let a = child as? Alien{
                    if a.position.y < self.frame.height/2{
                        aliensOnScreen.append(a)
                    }
                }
            }
        }
        
        let b = bomb!.copy() as! SKSpriteNode
        
        if aliensOnScreen.count > 0{
            b.name = "bombSquad"
            bombArray.append(b)
            b.position = aliensOnScreen[Int(arc4random_uniform(UInt32(aliensOnScreen.count)))].position
            b.position.y += -30
            b.physicsBody = SKPhysicsBody(texture: SKTexture(image: UIImage(named:"bomb")!), size: CGSize(width: 65, height: 65))
            b.position.x += 20
            b.physicsBody?.affectedByGravity = true
            b.physicsBody?.pinned = false
            self.addChild(b)
            
            b.physicsBody?.collisionBitMask = playerCategory
            b.physicsBody?.categoryBitMask = projectileCategory
            b.physicsBody?.contactTestBitMask = playerCategory
            
        }
    }
    
    @objc func dropsbullet() { //a is input alien from which sbullet is to be dropped
        
        var aliensOnScreen = [SKSpriteNode]()
        
        
        for child in self.children {
            if type(of: child) == Alien.self {
                if let a = child as? Alien{
                    if a.position.y < self.frame.height/2{
                        aliensOnScreen.append(a)
                    }
                }
            }
        }
        
        let b = sbullet!.copy() as! SKSpriteNode
        
        if aliensOnScreen.count > 0{
            b.name = "sbulletSquad"
            sbulletArray.append(b)
            b.position = aliensOnScreen[Int(arc4random_uniform(UInt32(aliensOnScreen.count)))].position
            b.position.y += -30
            b.physicsBody = SKPhysicsBody(texture: SKTexture(image: UIImage(named:"bullet (1)")!), size: CGSize(width: 65, height: 65))
            b.position.x += 20
            b.physicsBody?.affectedByGravity = true
            b.physicsBody?.pinned = false
            self.addChild(b)
            
            b.physicsBody?.collisionBitMask = playerCategory
            b.physicsBody?.categoryBitMask = projectileCategory
            b.physicsBody?.contactTestBitMask = playerCategory
            
        }
    }
    @objc func shoot() {
        if playerAlive == true{
            let bulletA = bullet1?.copy() as! SKSpriteNode
            let bulletB = bullet2?.copy() as! SKSpriteNode
            
            //            bulletA.physicsBody = bullet1?.physicsBody
            //            bulletB.physicsBody = bullet2?.physicsBody
            //
            bulletA.position.x = (player?.position.x)! - 45
            bulletB.position.x = (player?.position.x)! + 45
            
            bulletA.position.y = (player?.position.y)! + 40
            bulletB.position.y = (player?.position.y)! + 40
            bulletA.zPosition = 30
            bulletB.zPosition = 30
            bulletA.run(SKAction.sequence([SKAction.move(by: CGVector(dx:0,dy:1500), duration: 2), SKAction.removeFromParent()]))
            bulletB.run(SKAction.sequence([SKAction.move(by: CGVector(dx:0,dy:1500), duration: 2), SKAction.removeFromParent()]))
            
            
            bullets.append(bulletA)
            bullets.append(bulletB)
            
            bulletA.physicsBody?.categoryBitMask = bulletCategory
            bulletB.physicsBody?.categoryBitMask = bulletCategory
            bulletA.physicsBody?.contactTestBitMask = alienCategory
            bulletB.physicsBody?.contactTestBitMask = alienCategory
            bulletA.physicsBody?.contactTestBitMask = spacecraftCategory
            bulletB.physicsBody?.contactTestBitMask = spacecraftCategory
            
            
            self.addChild(bulletA)
            self.addChild(bulletB)
            
            
        }
    }
    
    @objc func alienReplication() {
        if alienCounter < 20{
            let newAlien = alien?.copy() as! Alien
            let newAlien2 = alien?.copy() as! Alien
            newAlien2.isLeft = false
            newAlien.position.x = -self.frame.width/2 - 50
            newAlien2.position.x = self.frame.width/2 + 50
            //newAlien.position.y = CGFloat(arc4random_uniform(UInt32(self.frame.height/2)))
            newAlien.position.y = 400
            newAlien2.position.y = 200
            newAlien.zPosition = 25
            newAlien2.zPosition = 25
            
            newAlien.physicsBody = SKPhysicsBody(texture: alienTexture, size: newAlien.size)
            newAlien2.physicsBody = SKPhysicsBody(texture: alienTexture, size: newAlien2.size)
            
            newAlien.physicsBody?.affectedByGravity = false
            newAlien2.physicsBody?.affectedByGravity = false
            
            newAlien2.physicsBody?.collisionBitMask = bulletCategory
            newAlien.physicsBody?.collisionBitMask = bulletCategory
            newAlien.physicsBody?.categoryBitMask = alienCategory
            newAlien2.physicsBody?.categoryBitMask = alienCategory
            newAlien.physicsBody?.contactTestBitMask = bulletCategory
            newAlien2.physicsBody?.contactTestBitMask = bulletCategory
            
            self.addChild(newAlien)
            self.addChild(newAlien2)
        }
        
    }
    
    @objc func spacecraftReplication() {
        print(alienCounter)
        print(spacecraftCounter)
        if alienCounter > 20 && spacecraftCounter < 4{
            spacecraftCounter += 1
            let newSpacecraft = spacecraft?.copy() as! Spacecraft
            let newSpacecraft2 = spacecraft?.copy() as! Spacecraft
            newSpacecraft2.isLeft = false
            newSpacecraft.position.x = -self.frame.width/2 - 50
            newSpacecraft2.position.x = self.frame.width/2 + 50
            newSpacecraft.position.y = 400
            newSpacecraft2.position.y = 200
            newSpacecraft.zPosition = 25
            newSpacecraft2.zPosition = 25
            
            newSpacecraft.physicsBody = SKPhysicsBody(texture: spacecraftTexture, size: newSpacecraft.size)
            newSpacecraft2.physicsBody = SKPhysicsBody(texture: spacecraftTexture, size: newSpacecraft2.size)
            
            newSpacecraft.physicsBody?.affectedByGravity = false
            newSpacecraft2.physicsBody?.affectedByGravity = false
            
            newSpacecraft2.physicsBody?.collisionBitMask = bulletCategory
            newSpacecraft.physicsBody?.collisionBitMask = bulletCategory
            newSpacecraft.physicsBody?.categoryBitMask = spacecraftCategory
            newSpacecraft2.physicsBody?.categoryBitMask = spacecraftCategory
            newSpacecraft.physicsBody?.contactTestBitMask = bulletCategory
            newSpacecraft2.physicsBody?.contactTestBitMask = bulletCategory
            
            self.addChild(newSpacecraft)
            self.addChild(newSpacecraft2)
        }
        
        
    }
    
    
    var moveRight = false
    var moveLeft = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        
        if touchedNode.name == "helpButton"{
            if let view = self.view {
                // Load the SKScene from 'EndScene.sks'
                if let scene = SKScene(fileNamed: "HelpScreen") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFit
                    
                    // Present the scene
                    view.presentScene(scene)
                }
            }
        }
        
        
        if touchedNode.name == "playButton"{
            gameStarted = true
            startGame()
            playButton?.run(SKAction.sequence([SKAction.moveBy(x: 0, y: 1000, duration: 1), SKAction.removeFromParent()]))
            helpButton?.run(SKAction.sequence([SKAction.moveBy(x: -1000, y: 0, duration: 1), SKAction.removeFromParent()]))
            achievementButton?.run(SKAction.sequence([SKAction.moveBy(x: 1000, y: 0, duration: 1), SKAction.removeFromParent()]))
            
        }else {
            
            if location.x > 0{
                moveRight = true
            }
            
            if location.x < 0{
                moveLeft = true
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveRight = false
        moveLeft = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        
        if gameStarted {
            for bomb in bombArray {
                if bomb.position.y < -self.frame.height/2 - 65 {
                    bomb.removeFromParent()
                }
            }
            for sbullet in sbulletArray {
                if sbullet.position.y < -self.frame.height/2 - 65 {
                        sbullet.removeFromParent()
                    }
                }
            }
            
            for child in self.children {
                if type(of: child) == Alien.self {
                    if let a = child as? Alien {
                        a.move()
                        if a.position.x > self.frame.width/2 + 100 || a.position.x < -self.frame.width/2 - 100 {
                            a.removeFromParent()
                        }
                    }
                }
            }
            
            for child in self.children {
                if type(of: child) == Spacecraft.self {
                    if let s = child as? Spacecraft {
                        s.move()
                        if s.position.x > self.frame.width/2 + 100 || s.position.x < -self.frame.width/2 - 100 {
                            s.removeFromParent()
                        }
                    }
                }
            }
            
            
            if (title?.position.y)! > (-self.frame.height/2 - 200) {
                title?.position.y = ((title?.position.y)!) - 6
            }
                
            else {
                title!.removeFromParent()
            }
        }
        //Always Runs
        if (ground?.position.y)! > (-self.frame.height/2 - 200) {
            ground?.position.y = ((ground?.position.y)!) - 6
        } else {
            ground!.removeFromParent()
        }
        bg1?.position.y = (bg1?.position.y)! - 6
        bg2?.position.y = (bg2?.position.y)! - 6
        
        if (bg1?.position.y)! < -frame.size.height {
            bg1?.position.y = (bg1?.position.y)! + 2 * bg1!.size.height
        }
        if (bg2?.position.y)! < -frame.size.height {
            bg2?.position.y = (bg2?.position.y)! + 2 * bg2!.size.height
        }
        
        let rightBound = self.frame.width/2 - (player?.frame.width)!/2
        let leftBound = -self.frame.width/2 + (player?.frame.width)!/2
        
        if (player?.position.x)! <= rightBound{
            if moveRight == true {
                player?.position.x += 20
                bullet1?.position.x += 20
                bullet2?.position.x += 20
            }
            if player!.position.x > rightBound {
                player?.position.x = rightBound
                bullet1?.position.x = rightBound - 45
                bullet2?.position.x = rightBound + 45
                
            }
        }
        
        if (player?.position.x)! >= leftBound {
            
            if moveLeft == true {
                player?.position.x += -20
                bullet1?.position.x += -20
                bullet2?.position.x += -20
            }
            
            if player!.position.x < leftBound {
                player?.position.x = leftBound
                bullet1?.position.x = leftBound - 45
                bullet2?.position.x = leftBound + 45
                
            }
        }
    }
    
    @objc func gameOver() {
        if let view = self.view {
            // Load the SKScene from 'EndScene.sks'
            if let scene = SKScene(fileNamed: "EndScreen") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFit
                
                // Present the scene
                view.presentScene(scene)
            }
        }
    }
}



