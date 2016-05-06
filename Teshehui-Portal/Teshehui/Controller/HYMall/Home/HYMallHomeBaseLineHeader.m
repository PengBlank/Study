//
//  HYMallHomeBaseLineHeader.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeBaseLineHeader.h"

@implementation HYMallHomeBaseLineHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIImageView *lineView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, .5)];
//        lineView3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
//        [self.contentView addSubview:lineView3];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, .5)];
        line2.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self addSubview:line2];
    }
    return self;
}

@end
