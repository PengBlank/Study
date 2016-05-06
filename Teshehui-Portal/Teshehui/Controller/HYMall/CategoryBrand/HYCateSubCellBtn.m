//
//  HYCateSubCellBtn.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/22.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYCateSubCellBtn.h"

@implementation HYCateSubCellBtn

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect titleFrame = self.titleLabel.frame;
    CGRect imageFrame = self.imageView.frame;
    float maxwidth = (titleFrame.size.width/2 + 5 + imageFrame.size.width) * 2;
    float x = maxwidth >= self.frame.size.width ? 0 : (self.frame.size.width-maxwidth)/2 + imageFrame.size.width/2 + 5;
    titleFrame.origin.x = x;
    self.titleLabel.frame = titleFrame;
    imageFrame.origin.x =  CGRectGetMaxX(titleFrame) + 5;
    self.imageView.frame = imageFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
