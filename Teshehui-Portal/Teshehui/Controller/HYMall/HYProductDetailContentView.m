//
//  HYProductDetailContentView.m
//  Teshehui
//
//  Created by HYZB on 15/8/17.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductDetailContentView.h"

@implementation HYProductDetailContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.sendTouchMsgToResponder)
    {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.sendTouchMsgToResponder)
    {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (self.sendTouchMsgToResponder)
    {
        [self.nextResponder touchesCancelled:touches withEvent:event];
    }
}
 */

- (void)setContentOffset:(CGPoint)contentOffset
{
    if (contentOffset.x < 0)
    {
        self.sendTouchMsgToResponder = YES;
        return;
    }
    else
    {
        self.sendTouchMsgToResponder = NO;
    }
    
    [super setContentOffset:contentOffset];
}


@end
