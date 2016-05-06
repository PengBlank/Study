//
//  UIImageView+Addtion.h
//  Teshehui
//
//  Created by ChengQian on 13-10-25.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Addtion)

-(void)scaleWithDuration:(float)duration toScale:(float)toValue delegate:(id)delegate;
- (void)pauseLayer;
- (void)resumeLayer;
- (void)stopLayer;

@end
