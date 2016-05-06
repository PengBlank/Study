//
//  HYHotelMainCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelMainCell.h"

@implementation HYHotelMainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.detailTextLabel.frame = CGRectMake(140, 12, 160, 20);
}

@end
