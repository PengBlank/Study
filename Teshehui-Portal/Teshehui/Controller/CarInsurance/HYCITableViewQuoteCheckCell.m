//
//  HYCITableViewQuoteCheckCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/6/30.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCITableViewQuoteCheckCell.h"

@implementation HYCITableViewQuoteCheckCell

- (void)awakeFromNib {
    // Initialization code
    self.hiddenLine = YES;
    [self.checkBtn addTarget:self
                      action:@selector(checkAction:)
            forControlEvents:UIControlEventTouchUpInside];
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
    
    frame = self.checkBtn.frame;
    frame.origin.x = width + 10;
    frame.size.width = width - 20;
    self.checkBtn.frame = frame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)checkAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(checkCellDidCheck:)])
    {
        [self.delegate checkCellDidCheck:self];
    }
}

@end
