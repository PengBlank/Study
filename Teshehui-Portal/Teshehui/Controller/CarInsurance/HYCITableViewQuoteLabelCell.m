//
//  HYCITableViewQuoteLabelCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCITableViewQuoteLabelCell.h"

@implementation HYCITableViewQuoteLabelCell

- (void)awakeFromNib {
    // Initialization code
    self.hiddenLine = YES;
    self.priceLab.textColor = [UIColor colorWithRed:161.0/255.0
                                              green:0
                                               blue:0
                                              alpha:1.0];
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
    
    frame = self.priceLab.frame;
    frame.origin.x = 2*width + 10;
    frame.size.width = width - 20;
    self.priceLab.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
