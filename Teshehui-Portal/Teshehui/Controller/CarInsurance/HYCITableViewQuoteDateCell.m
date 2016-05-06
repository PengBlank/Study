//
//  HYCITableViewQuoteDateCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCITableViewQuoteDateCell.h"

@implementation HYCITableViewQuoteDateCell

- (void)awakeFromNib {
    // Initialization code
    self.hiddenLine = YES;
    
    UIImage *selectBg = [UIImage imageNamed:@"input_bj"];
    selectBg = [selectBg resizableImageWithCapInsets:UIEdgeInsetsMake(3, 4, 4, 3) resizingMode:UIImageResizingModeStretch];
    [self.dateBtn setBackgroundImage:selectBg forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //对于三个标题头label，重新排列以适应不同屏幕
    CGFloat width = CGRectGetWidth(self.bounds) / 3.0;
    CGRect frame = self.nameLab.frame;
    frame.origin.x = 10;
    frame.size.width = width-20;
    self.nameLab.frame = frame;
    
    frame = self.dateBtn.frame;
    frame.origin.x = width + 10;
    frame.size.width = width - 20;
    self.dateBtn.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
