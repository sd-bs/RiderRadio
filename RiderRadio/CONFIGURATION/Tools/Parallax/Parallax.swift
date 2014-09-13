//
//  Parallax.swift
//
//  Created by Fabien on 31/07/2014.
//  Copyright (c) 2014 Fabien Moussavi. All rights reserved.
//


import UIKit


//===========//
/*   CLASS   */
//===========//
class Parallax {
    
    //**/ Statics
    //====================================================================================================//
    /*
    * To Have a paralax effect on the view passed in argument
    */
    class func registerEffectForView(aView: UIView, depth: CGFloat)
    {
        var effectX: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        var effectY: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        
        effectX.minimumRelativeValue = -depth
        effectX.maximumRelativeValue = depth
        effectY.minimumRelativeValue = -depth
        effectY.maximumRelativeValue = depth
        
        var group: UIMotionEffectGroup = UIMotionEffectGroup()
        group.motionEffects = [effectX, effectY]
        
        aView.addMotionEffect(group)
    }
    
}

