//
//  UIImageView+Addtion.m
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "UIImageView+Addtion.h"

@implementation UIImageView (Addtion)

-(void)scaleWithDuration:(float)duration toScale:(float)toValue delegate:(id)delegate
{
    [self.layer removeAllAnimations];
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.duration = duration;
    theAnimation.fillMode = kCAFillModeForwards;
    theAnimation.delegate = delegate;
    theAnimation.removedOnCompletion = NO;
    theAnimation.toValue = [NSNumber numberWithFloat:toValue];
    [theAnimation setValue:@"ScaleTransform" forKey:@"AnimationName"];
    [self.layer addAnimation:theAnimation forKey:@"ScaleTransform"];
}

- (void)pauseLayer
{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed= 0.0;
    self.layer.timeOffset= pausedTime;
}
- (void)resumeLayer
{
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed= 1.0;
    self.layer.timeOffset= 0.0;
    self.layer.beginTime= 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime= timeSincePause;
}
- (void)stopLayer
{
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed= 1.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.timeOffset= timeSincePause;
}


@end
