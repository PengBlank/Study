//
//  HYTestView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYTestView.h"

@implementation HYTestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)removeFromSuperview
{
    NSLog(@"removeFromSuperview");
    [super removeFromSuperview];
}

@end
