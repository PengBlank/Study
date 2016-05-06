//
//  HYProductFilterPriceCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/5.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductFilterPriceCell.h"

@interface HYProductFilterPriceCell ()



@end

@implementation HYProductFilterPriceCell

- (void)awakeFromNib
{
    // Initialization code
    self.minField.layer.borderWidth = .5;
    self.minField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.minField.layer.cornerRadius = 1;
    self.maxField.layer.borderWidth = .5;
    self.maxField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.maxField.layer.cornerRadius = 1;
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
