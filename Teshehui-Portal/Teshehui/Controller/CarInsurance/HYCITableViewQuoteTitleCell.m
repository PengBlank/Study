//
//  HYCITableViewQuoteTitleCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCITableViewQuoteTitleCell.h"

@implementation HYCITableViewQuoteTitleCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //对于三个标题头label，重新排列以适应不同屏幕
    CGFloat width = CGRectGetWidth(self.bounds) / 3.0;
    CGRect frame = self.cateLab.frame;
    frame.origin.x = 0;
    frame.size.width = width;
    self.cateLab.frame = frame;
    
    frame = self.amountLab.frame;
    frame.origin.x = width;
    frame.size.width = width;
    self.amountLab.frame = frame;
    
    frame = self.priceLab.frame;
    frame.origin.x = 2*width;
    frame.size.width = width;
    self.priceLab.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
