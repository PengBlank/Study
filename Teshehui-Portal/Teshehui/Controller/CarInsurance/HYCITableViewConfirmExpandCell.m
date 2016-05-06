//
//  HYCITableViewExpandCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCITableViewConfirmExpandCell.h"

@implementation HYCITableViewConfirmExpandCell

- (void)setExpand:(BOOL)expand
{
    CGAffineTransform transform = expand ? CGAffineTransformMakeRotation(M_PI_2) : CGAffineTransformIdentity;
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
    {
        b_self.indicator.transform = transform;
    }];
}

- (void)awakeFromNib {
    // Initialization code
    self.nameLab.textColor = [UIColor colorWithRed:161.0/255.0
                                             green:0
                                              blue:0
                                             alpha:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
