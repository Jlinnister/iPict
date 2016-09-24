//
//  ExplodeView.swift
//  iPict
//
//  Created by Jim Wang on 9/23/16.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation

import UIKit

class ExplodeView: UIView {
    //1
    private var emitter:CAEmitterLayer!
    required init(coder aDecoder:NSCoder) {
        fatalError("use init(frame:")
    }


    override init(frame:CGRect) {
        super.init(frame:frame)
        
        //initialize the emitter
        let emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width/2,y: self.bounds.size.height/2)
        emitter.emitterSize = self.bounds.size
        emitter.emitterMode = kCAEmitterLayerAdditive
        emitter.emitterShape = kCAEmitterLayerRectangle
    }
    
    override class var layerClass: AnyClass {
        //configure the UIView to have emitter layer
        return CAEmitterLayer.self
    }
    //2 configure the UIView to have an emitter layer
        override func didMoveToSuperview() {
        //1
        super.didMoveToSuperview()
        if self.superview == nil {
            return
        }
        
        //2
        let texture:UIImage? = UIImage(named:"Particle.png")
        assert(texture != nil, "particle image not found")
        
        //3
        let emitterCell = CAEmitterCell()
        
        //4
        emitterCell.contents = texture!.cgImage
        
        //5
        emitterCell.name = "cell"
        //6
        emitterCell.birthRate = 1000
        emitterCell.lifetime = 0.75
        
        //7
        emitterCell.blueRange = 0.33
        emitterCell.blueSpeed = -0.33
        
        //8
        emitterCell.velocity = 160
        emitterCell.velocityRange = 40
        
        //9
        emitterCell.scaleRange = 0.5
        emitterCell.scaleSpeed = -0.2
        
        //10
        emitterCell.emissionRange = CGFloat(M_PI*2)
        
        //11
        emitter.emitterCells = [emitterCell]
    }

}
