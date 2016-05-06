//
//  HYChannelTitleCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYChannelTitleCell.h"

@implementation HYChannelTitleCell

- (void)layoutSubviews
{
    self.separatorLeftInset = 0;
    [super layoutSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.frame = CGRectMake(12, 0, self.frame.size.width-12, CGRectGetHeight(self.frame));
    self.textLabel.font = [UIFont systemFontOfSize:14.0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
