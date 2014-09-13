//
//  Parallax.m
//
//  Created by Fabien on 02/09/2014.
//  Copyright (c) 2014 Fabien Moussavi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Parallax.h"


@implementation Parallax

/*
 * To Have a paralax effect on the view passed in argument
 */
+ (void)registerEffectForView:(UIView *)view withDepth:(CGFloat)depth
{
    UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    [effectX setMinimumRelativeValue:@(depth)];
    [effectX setMaximumRelativeValue:@(-depth)];
    [effectY setMinimumRelativeValue:@(depth)];
    [effectY setMaximumRelativeValue:@(-depth)];
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[effectX, effectY];
    
    [view addMotionEffect:group];
}

@end