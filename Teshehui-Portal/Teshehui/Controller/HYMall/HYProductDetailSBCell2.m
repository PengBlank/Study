//
//  HYProductDetailSBCell2.m
//  Teshehui
//
//  Created by Kris on 16/4/18.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYProductDetailSBCell2.h"

@implementation HYProductDetailSBCell2

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(14, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
}

@end
