//
//  HYClearHistoryCell.m
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYClearHistoryCell.h"

@implementation HYClearHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = self.bounds;
}

- (void)setHasHistory:(BOOL)hasHistory
{
    if (hasHistory)
    {
        self.clearBtn.hidden = NO;
        self.textLabel.hidden = YES;
    }
    else
    {
        self.clearBtn.hidden = YES;
        self.textLabel.hidden = NO;
        self.textLabel.text = @"暂无历史记录";
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.textLabel.textColor = [UIColor colorWithWhite:.8 alpha:1];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
}

@end
